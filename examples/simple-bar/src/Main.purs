module Main where

-- This file has a top-down structure: first we define higher-level things,
-- like the main export or the sections of the bar, and then we define
-- lower-level things like implementations of specific widgets.

import Prelude

import AGS.Binding (Binding)
import AGS.Service as Service
import AGS.Service.Hyprland as H
import AGS.Utils.Exec as Exec
import AGS.Variable as Var
import AGS.Widget (Widget)
import AGS.Widget as Widget
import AGS.Widget.Window (Window, window) as Window
import AGS.Widget.Window.Anchor (left, right, top) as Window
import AGS.Widget.Window.Exclusivity (exclusive) as Window
import Control.Apply (lift2)
import Data.Array (foldMap)
import Data.Array as A
import Data.DateTime as DT
import Data.Formatter.DateTime as FDT
import Data.Int (toNumber)
import Data.List as List
import Data.Maybe (Maybe(..), maybe)
import Data.Monoid (guard)
import Data.Monoid.Additive (Additive(..))
import Data.Newtype (alaF)
import Data.Number.Format as NumberFormat
import Data.Time.Duration (negateDuration)
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Now as Now
import Untagged.Union (asOneOf)
import Yoga.JSON as JSON

-- Our `main` value will export an array of `Window`s.
-- This will be imported and executed out of the `Effect` wrapping
-- by the helper `entrypoint.js` file.
-- We only declare one window for this configuration (the bar), but
-- it's possible to define many windows and toggle their visibility on demand.

main ∷ Effect { windows ∷ Array Window.Window }
main = ado
  bar ← barWindow
  in { windows: [ bar ] }

-- This is the window we're going to use.
-- It uses one child widget `barCenterBox`, which is declared just below.
-- A widget's child (and, in fact, all other properties) could be
-- of type `Widget` (a static widget) or `Binding Widget`,
-- a dynamically updated wrapping over a `Widget`.
-- Although it's an untagged union, for all widgets it's not needed
-- to wrap them with `Untagged.Union.asOneOf`. But windows are special
-- and require explicit wrapping of child widgets.

barWindow ∷ Effect Window.Window
barWindow = do
  box ← barCenterBox
  Window.window
    { child: asOneOf box
    , name: "barWindow"
    , anchor: [ Window.top, Window.left, Window.right ]
    , exclusivity: Window.exclusive
    }

barCenterBox ∷ Effect Widget
barCenterBox = ado
  left ← barLeft
  center ← barCenter
  right ← barRight
  in
    Widget.centerBox
      { startWidget: left
      , centerWidget: center
      , endWidget: right
      }

-- The widget created by `AGS.Widget.box` can have
-- multiple children. As before, it can be either `Array Widget`
-- or `Binding (Array Widget)`.

barLeft ∷ Effect Widget
barLeft = ado
  wss ← workspaces
  in
    Widget.box
      { children: wss
      }

barCenter ∷ Effect Widget
barCenter = ado
  dtButton ← dateTimeButton
  in
    Widget.box
      { children: [ dtButton ]
      }

barRight ∷ Effect Widget
barRight = ado
  sysStats ← sysStatsToggleable
  volume ← volumeToggleable
  in
    Widget.box
      { children: [ sysStats, volume ]
      , hpack: "end"
      }

-- * Volume

-- `AGS.Utils.Exec` provides the means to execute external commands,
-- synchronously or asynchronously. In the former case, the function
-- `exec` takes a single string as the command. In the latter case,
-- it takes an array of strings to separate the command and its arguments.
-- NOTE: Commands are not wrapped in a shell, this has to be done explicitly.

-- `AGS.Variable` exports multiple functions to work with mutable data.
-- A `Variable` is an opaque type with methods for getting and setting current value.
-- It can be obtained either by storing a pure value (`Variable.store`), or
-- by listening to the output of an external command (`Variable.listen`), or
-- by polling (executing periodically with `Variable.poll`) an external command.
-- Finally, a variable can be created by polling a value of type `Effect a` with `Variable.serve`.
-- After a variable is obtained, it can be made into a `Binding`
-- with `Variable.bindValue` to be used with widgets.

volumeToggleable ∷ Effect Widget
volumeToggleable = do
  initValue ← Exec.exec $ "pamixer --get-volume-human"
  lvlBinding ←
    Var.bindValue
      <$>
        Var.listen
          { command: [ "sh", "-c", volumeCommand ]
          , initValue
          , transform: const identity
          }

  let
    display = Var.store false

    -- `Binding`s can be thought of as effectful streams.
    -- They have instances for `Functor`, `Apply`, `Applicative` and
    -- `Bind` type classes, and as such we can compose them with do/ado notation.
    -- Via `Applicative` instance bindings also have `Semigroup` and `Monoid` instances.
    -- When multiple bindings are composed together, the resulting binding
    -- will be updated whenever any of its components get updated.
    -- See the next widgets for more examples of how to utilize variables and bindings.

    label =
      Widget.label
        { label:
            ado
              display' ← Var.bindValue display
              lvl' ← lvlBinding
              in if display' then "volume: " <> lvl' else "  "
        }

  pure $ Widget.button
    { child: label
    , onClicked: Var.set not display
    }

volumeCommand ∷ String
volumeCommand =
  """
pactl subscribe \
  | rg --line-buffered sink \
  | while read -r _; do
      pamixer --get-volume-human
    done
"""

-- * RAM and CPU stats

sysStatsToggleable ∷ Effect Widget
sysStatsToggleable = ado
  cpu ← Var.bindValue <$> cpuLoad
  ram ← Var.bindValue <$> ramStats

  let
    display = Var.store false

    label = Widget.label
      { label:
          ado
            cpu' ← cpu
            ram' ← ram
            display' ← Var.bindValue display
            in
              case display', cpu', ram' of
                false, _, _ → "  "
                _, Nothing, _ → "Error retrieving CPU data"
                _, _, Nothing → "Error retrieving RAM data"
                _, Just c, Just r → printStats c r
      }

  in
    Widget.button
      { child: label
      , onClicked: Var.set not display
      }

  where
  printStats cpu ram =
    A.fold
      [ "ram: "
      , pprintPercentage $ 100.0 * (1.0 - (ram."MemAvailable" / ram."MemTotal"))
      , ", swap: "
      , pprintPercentage $ 100.0 * (1.0 - (ram."SwapFree" / ram."SwapTotal"))
      , ", cpu: "
      , pprintPercentage $ cpu
      ]

  pprintPercentage n =
    NumberFormat.toStringWith (NumberFormat.precision 3) n <> "%"

cpuLoad ∷ Effect (Var.Variable (Maybe Number))
cpuLoad =
  Var.poll
    { command: [ "sh", "-c", "top -b -d 0.5 -n 4 | jc --top -q" ]
    , initValue: Nothing
    , interval: 3000
    , transform:
        JSON.readJSON_ @(_ { cpu_idle ∷ Number }) >>> map ado
          all ← foldMap `alaF Additive` _.cpu_idle
          count ← A.length
          in 100.0 - (all / toNumber count)
    }

type RamStats a =
  { "MemAvailable" ∷ a
  , "MemTotal" ∷ a
  , "SwapFree" ∷ a
  , "SwapTotal" ∷ a
  }

ramStats ∷ Effect (Var.Variable (Maybe (RamStats Number)))
ramStats =
  Var.poll
    { command: [ "sh", "-c", "jc --proc < /proc/meminfo" ]
    , initValue: Nothing
    , interval: 3000
    , transform: JSON.readJSON_
    }

-- * Date and time

dateTimeButton ∷ Effect Widget
dateTimeButton = do
  now ← Now.nowDateTime
  offset ← Now.getTimezoneOffset
  dtVar ← Var.serve
    { initValue: now
    , command: Now.nowDateTime
    , interval: 1000
    }

  let
    ftVar = Var.store dtFormatLong

    formatDT ft' =
      DT.adjust (negateDuration offset)
        >>> maybe "Can't adjust datetime for timezone" (FDT.format ft')

    label = Widget.label
      { label: lift2 formatDT (Var.bindValue ftVar) (Var.bindValue dtVar)
      }

    flipFt curr
      | curr == dtFormatLong = dtFormatShort
      | otherwise = dtFormatLong

  pure $ Widget.button
    { child: label
    , onClicked: Var.set flipFt ft
    }

  where
  dtFormatLong = List.fromFoldable
    [ FDT.MonthShort
    , FDT.Placeholder " "
    , FDT.DayOfMonth
    , FDT.Placeholder " / "
    , FDT.YearFull
    , FDT.Placeholder " / "
    , FDT.Hours24
    , FDT.Placeholder ":"
    , FDT.MinutesTwoDigits
    , FDT.Placeholder ":"
    , FDT.SecondsTwoDigits
    ]

  dtFormatShort = List.fromFoldable
    [ FDT.MonthShort
    , FDT.Placeholder " "
    , FDT.DayOfMonth
    , FDT.Placeholder ", "
    , FDT.Hours24
    , FDT.Placeholder ":"
    , FDT.MinutesTwoDigits
    ]

-- * Workspaces

-- Finally, let's take a look at `Service`s.
-- Services are similar to Variables in that they hold some value,
-- and can be made into Bindings. Since Services are available statically and
-- don't require passing any values, we obtain them with `bindServiceProp` and
-- Visible Type Application.

workspaces ∷ Effect (Binding (Array Widget))
workspaces = ado
  workspacesBinding ←
    Service.bindServiceProp @H.Hyprland @"workspaces"

  activeWorkspaceIdBinding ←
    map _.id <$> Service.bindServiceProp @H.HyprlandActive @"workspace"

  let

    -- Here we turn a `Binding (Array WorkspaceRecord)` into `Binding (Array Widget)`.
    -- The array of widgets will grow (or shrink) and change in line with how
    -- the value of the underlying binding changes.

    wssWidgets =
      workspacesBinding
        <#> A.sort >>> map \{ id } →
          Widget.button
            { child:
                Widget.label
                  { label: show id
                  }
            , onClicked:
                Aff.launchAff_ do
                  void $ H.messageAsync $ "dispatch workspace " <> show id
            , className:
                activeWorkspaceIdBinding
                  <#> \actId →
                    guard (actId == id) "focused"
            }

  in wssWidgets


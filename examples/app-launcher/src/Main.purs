module Main where

import Prelude

import AGS.Binding (Binding)
import AGS.Service.App as App
import AGS.Service.Applications (Application)
import AGS.Service.Applications as Applications
import AGS.Variable (Variable)
import AGS.Variable as Var
import AGS.Widget (Widget, Window)
import AGS.Widget as Widget
import Data.Array as A
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (asOneOf)

{- This is the main export: an array of `AGS.Widget.Window`.
A window is the root of a widget tree. Multiple windows can run at the same time,
and their visibility can be toggled on and off.
-}
main ∷ Effect { windows ∷ Array Window }
main = do
  appList' ← appList

  window ← Widget.window
    { name: "App launcher"
    , popup: true
    , visible: true
    , keymode: "on-demand"
    , child: asOneOf appList'
    }

  pure { windows: [ window ] }

{- This is the main widget we're going to use.
It will feature an input box for the search query and
a list of applications which match this query.
-}
appList ∷ Effect Widget
appList = do
  -- First, we need to get the list of all applications using
  -- `AGS.Service.Applications.query`.
  allApps ∷ Array Application ← Applications.query ""

  let
    -- Here, we create a `Variable` which will store the search query.
    -- A `Variable` is similar to `Ref`. Its advantage is that it can be
    -- turned into a `Binding` with `bindValue`, and this binding can then
    -- be used as the value for widget properties.
    -- A variable can created out of a pure value with `store` function, but it
    -- can also `poll` and `listen` to the output of external commands, as well as
    -- periodically execute an effectful action using `serve` function.
    currQueryVar ∷ Variable String
    currQueryVar = Var.store ""

    -- This binding will be used by widgets of particular applications so that they "know"
    -- when the value of their `visible` property should be set to `true`.
    currQuery ∷ Binding String
    currQuery = Var.bindValue currQueryVar

    apps ∷ Widget
    apps =
      Widget.scrollable
        -- Since many widget properties accept either a "raw" value or a binding for
        -- that value, it's necessary to wrap them usin `Untagged.Union.asOneOf`.
        { child: asOneOf $
            Widget.box
              -- We use the function `appEntry` declared below and pass it the binding to
              -- the search query to construct an array of widgets each representing
              -- a particular application.
              { children: asOneOf $
                  let
                    appWidgets ∷ Array Widget
                    appWidgets = appEntry currQuery <$> allApps
                  in
                    appWidgets
              , vertical: true
              , spacing: 5.0
              }
        , hscroll: "never"
        , css: "min-width: 500px; min-height: 300px;"
        }

    entryBox = Widget.entry
      { hexpand: asOneOf true
      , css: "margin-bottom: 5px;"
      -- When the search query is accepted with the Enter key,
      -- we get the value of the variable of the applications,
      -- find the right one and launch it.
      , onAccept: mkEffectFn1 \_ → do
          query ← Var.get currQueryVar
          allApps
            # A.filter (Applications.matchAppName query)
            # A.head
            # maybe mempty \(app ∷ Application) → do
                Applications.launchApp app
                App.quit
      -- When input is received, we update the value stored in
      -- the variable holding the search query, so that the list
      -- of applications' widgets could be updated.
      , onChange: mkEffectFn1 \w → do
          let text = (unsafeCoerce w).text
          Var.set (const text) currQueryVar
      }

  Widget.grabFocus entryBox

  pure $ Widget.box
    { vertical: true
    , css: "margin: 10px;"
    , children: asOneOf [ entryBox, apps ]
    }

appEntry ∷ Binding String → Applications.Application → Widget
appEntry currQuery app =
  let
    -- Here, we turn an opaque `Application` into a plain record
    -- to extract some info for the given application.
    { name, "icon-name": iconName } =
      Applications.fromApplication app

    icon = Widget.icon
      { icon: iconName
      , size: 20.0
      }

    label = Widget.label
      { className: asOneOf "appTitle"
      , label: asOneOf name
      , xalign: 0.0
      , vpack: "center"
      , truncate: "end"
      }

    buttonChild = Widget.box
      { children: asOneOf [ icon, label ]
      , spacing: 5.0
      }

    -- Here, we declare a helper function to be used with the
    -- binding for current search query. It will check if the
    -- query matches the app. As such, the binding for the query
    -- could be transformed to be applied this function, and in
    -- return we will get a `Binding Boolean`, which can be used
    -- as the value for the `visible` property of our widget.
    filterEntry ∷ String → Boolean
    filterEntry s =
      Applications.matchAppName s app

    visible ∷ Binding Boolean
    visible = filterEntry <$> currQuery

  in
    Widget.button
      { child: asOneOf buttonChild
      , onClicked: do
          Applications.launchApp app
          App.quit
      -- `Binding` has a Functor, Apply, Applicative and Monad instances,
      -- as well as Semigroup and Monoid. We can use `map` to directly
      -- transform the binding.
      , visible: asOneOf visible
      }


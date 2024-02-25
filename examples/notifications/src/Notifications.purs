module Notifications where

-- Let's use AGS as a notification daemon.
-- We will create a widget which will hold children widgets
-- for each notification that should be displayed at a
-- specific moment. When either the notification gets
-- dismissed by clicking on it, or the notification timeout expires,
-- its corresponding widget will be destroyed.

import Prelude

import AGS.Binding (overBoth')
import AGS.Service (connectService)
import AGS.Service.App as App
import AGS.Service.Notifications as N
import AGS.Utils.Icon (lookupIcon) as Icon
import AGS.Variable (Variable)
import AGS.Variable as Var
import AGS.Widget (Widget, asOneOf, mkEffectFn1)
import AGS.Widget as Widget
import AGS.Widget.Window (Window)
import AGS.Widget.Window (window) as Window
import AGS.Widget.Window.Anchor (right, top) as WindowAnchor
import Control.Alternative (alt)
import Control.Apply (lift2)
import Data.Array as A
import Data.Foldable (for_)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..), maybe)
import Data.Time.Duration (Milliseconds(..))
import Data.Traversable (traverse)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Gtk.IconInfo (filename) as Icon

-- First, create a window for the widget.
-- We will also apply some CSS and set
-- a default notification expiration timeout.

main ∷ Effect { windows ∷ Array Window }
main = do

  popups ← popupList

  notificationsWindow ←
    Window.window
      { child: asOneOf popups
      , name: "notifications"
      , anchor: [ WindowAnchor.top, WindowAnchor.right ]
      }

  -- Set the timeout to 15 seconds.
  N.setOptions _ { popupTimeout = Milliseconds 15000.0 }

  -- Apply some styles.
  App.applyCss styles

  pure { windows: [ notificationsWindow ] }

-- This is the "root" widget that will hold children widgets
-- for notifications.
popupList ∷ Effect Widget
popupList = do

  let
    -- We will use a `Variable` holding a map with notification
    -- ids as keys and widgets as values. This is done
    -- so that widgets for notifications with same ids could be
    -- replaced (destroyed and created again).
    widgetMapVar ∷ Variable (Map N.NotificationID Widget)
    widgetMapVar = Var.store Map.empty

    box /\ updateBox = Widget.box'
      { vertical: true
      -- As this is the root widget, we need to force some
      -- initial size on it, otherwise it won't render.
      , css: "padding: 1px;"
      }

    -- This is a hook which will be run when a notification
    -- gets dismissed, or its timeout expires, or when it
    -- should be replaced.
    remove ∷ EffectFn1 N.NotificationID Unit
    remove = mkEffectFn1 \id → do
      widgetMap ← Var.get widgetMapVar
      for_ (Map.lookup id widgetMap) \w → do
        -- Destroy the widget
        Widget.destroy w
        -- Remove it from the map
        Var.set (Map.delete id) widgetMapVar

    -- This is a hook which will be run when a new
    -- notification should be displayed.
    add ∷ EffectFn1 N.NotificationID Unit
    add = mkEffectFn1 \id →
      -- If "do not disturb" mode is on, don't display notifications.
      unlessM (_.dnd <$> N.getOptions) do
        runEffectFn1 remove id
        popup ← N.getPopup id
        for_ popup \p → do
          -- Create a widget and add it to the map.
          w ← notificationWidget p
          Var.set (Map.insert id w) widgetMapVar
          -- Add the notification widget as a child to the root widget.
          updateBox \b → b { children = overBoth' (A.cons w) b.children }

  -- Set up the hooks.
  void $ connectService @N.Notifications @"notified" add
  void $ connectService @N.Notifications @"dismissed" remove
  void $ connectService @N.Notifications @"closed" remove

  pure box

-- This function creates a widget out of a notification.
notificationWidget ∷ N.Notification → Effect Widget
notificationWidget n = do
  -- Get an icon widget for this notification.
  mbIcon ← notificationIcon n

  let
    { summary, body, actions, urgency } = N.fromNotification n

    mbIconBox =
      Widget.box
        <<<
          { vpack: "start"
          , className: "icon"
          , child: _
          }
        <$> mbIcon

    titleLabel = Widget.label
      { className: "title"
      , xalign: 0.0
      , justification: "left"
      , hexpand: true
      , maxWidthChars: 24.0
      , truncate: "end"
      , wrap: true
      , label: summary
      , useMarkup: true
      }

    bodyLabel = Widget.label
      { className: "body"
      , hexpand: true
      , useMarkup: true
      , xalign: 0.0
      , justification: "left"
      , label: body
      , wrap: true
      }

    mkActionButton ∷ N.Action → Widget
    mkActionButton a =
      Widget.button
        { className: "actionButton"
        , onClicked: N.invoke n a
        , hexpand: true
        , child:
            Widget.label
              { label: show $ _.label $ N.fromAction a
              }
        }

    actionsBox = Widget.box
      { className: "actions"
      , children: mkActionButton <$> actions
      }

    titleAndBodyBox = Widget.box
      { vertical: true
      , children: [ titleLabel, bodyLabel ]
      }

    iconAndNotificationBox = Widget.box
      $ { children: _ }
      $ maybe mempty A.singleton mbIconBox <> [ titleAndBodyBox ]

    finalBox = Widget.box
      { className: "notification " <> show urgency
      , vertical: true
      , children: [ iconAndNotificationBox, actionsBox ]
      }

  -- When a notification is clicked on, it will be dismissed, thus triggering the hook
  -- we set up earlier which will destroy this widget.
  pure $ Widget.eventBox
    { onPrimaryClick: N.dismiss n
    , child: finalBox
    }

notificationIcon ∷ N.Notification → Effect (Maybe Widget)
notificationIcon n
  | { appEntry, appIcon, image } ← N.fromNotification n =
      case image of
        -- If image is available, use that
        Just s → pure $ pure $ Widget.box { css: mkBackground s }
        -- Otherwise, use `appIcon` or `appEntry`
        Nothing → lift2 alt (mkWidget $ pure appIcon) (mkWidget appEntry)

      where
      mkWidget ∷ Maybe String → Effect (Maybe Widget)
      mkWidget i = ado
        icon ← traverse (flip Icon.lookupIcon 16) i
        in join icon >>= Icon.filename <#> (Widget.icon <<< { icon: _ })

      mkBackground ∷ String → String
      mkBackground s =
        """
    background-image: url("""" <> s <>
          """");
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
"""

-- This could be placed in a separate CSS file as well, but is provided here
-- to simplify project structure.
styles ∷ String
styles =
  """
window#notifications {
    all: unset;
}

window#notifications box.notifications {
    padding: .5em;
}

.icon {
    min-width: 68px;
    min-height: 68px;
    margin-right: 1em;
}

.icon image {
    font-size: 58px;
    /* to center the icon */
    margin: 5px;
    color: @theme_fg_color;
}

.icon box {
    min-width: 68px;
    min-height: 68px;
    border-radius: 7px;
}

.notification {
    min-width: 350px;
    border-radius: 11px;
    padding: 1em;
    margin: .5em;
    border: 1px solid @wm_borders_edge;
    background-color: @theme_bg_color;
}

.notification.critical {
    border: 1px solid lightcoral;
}

.title {
    color: @theme_fg_color;
    font-size: 1.4em;
}

.body {
    color: @theme_unfocused_fg_color;
}

.actions .action-button {
    margin: 0 .4em;
    margin-top: .8em;
}

.actions .action-button:first-child {
    margin-left: 0;
}

.actions .action-button:last-child {
    margin-right: 0;
}  
"""


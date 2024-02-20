module AGS.Widget.Menu.Item (MenuItemProps, menuItem, menuItem') where

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Effect (Effect)
import Gtk.Actionable (GtkActionableProps)
import Gtk.Activatable (GtkActivatableProps)
import Gtk.Container (GtkContainerProps)
import Gtk.MenuItem (GtkMenuItemProps)
import Gtk.Widget (Widget)
import Prelude ((<<<))
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type MenuItemProps r =
  AGSWidgetProps
    + GtkActionableProps
    + GtkActivatableProps
    + GtkContainerProps
    -- should be somehow constrained to `Menu` rather than all widgets
    + GtkMenuItemProps Widget
    +
      ( child ∷ ValueOrBinding Widget
      , onActivate ∷ ValueOrBinding (Effect Boolean)
      , onSelect ∷ ValueOrBinding (Effect Boolean)
      , onDeselect ∷ ValueOrBinding (Effect Boolean)
      | r
      )

menuItem ∷ MkWidget (MenuItemProps ())
menuItem = menuItemImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(MenuItemProps ())

menuItem' ∷ MkWidgetWithUpdates (MenuItemProps ())
menuItem' = mkWidgetWithUpdates menuItem

foreign import menuItemImpl ∷ Record (MenuItemProps ()) → Widget


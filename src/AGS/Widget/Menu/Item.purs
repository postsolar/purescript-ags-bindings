module AGS.Widget.Menu.Item where

import AGS.Widget.Internal (AGSWidgetProps)
import Effect (Effect)
import Gtk.Actionable (GtkActionableProps)
import Gtk.Activatable (GtkActivatableProps)
import Gtk.Container (GtkContainerProps)
import Gtk.MenuItem (GtkMenuItemProps)
import Gtk.Widget (Widget)
import Prelude ((<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

foreign import data MenuItem ∷ Type

type MenuItemProps r =
  AGSWidgetProps
    + GtkActionableProps
    + GtkActivatableProps
    + GtkContainerProps
    -- should be somehow constrained to `Menu` rather than all widgets
    + GtkMenuItemProps Widget
    +
      ( child ∷ Widget
      , onActivate ∷ Effect Boolean
      , onSelect ∷ Effect Boolean
      , onDeselect ∷ Effect Boolean
      | r
      )

menuItem ∷ ∀ r r'. Union r r' (MenuItemProps ()) ⇒ Record r → MenuItem
menuItem = menuItemImpl <<< unsafeCoerce

foreign import menuItemImpl ∷ Record (MenuItemProps ()) → MenuItem


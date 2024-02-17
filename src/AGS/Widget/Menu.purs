module AGS.Widget.Menu
  ( MenuProps
  , UpdateMenuProps
  , menu
  , menu'
  , module AGS.Widget.Menu.Item
  ) where

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import AGS.Widget.Menu.Item (MenuItem, MenuItemProps, menuItem, menuItemImpl)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Gtk.Container (GtkContainerProps)
import Gtk.Menu (GtkMenuProps)
import Gtk.MenuShell (GtkMenuShellProps)
import Gtk.ScrollType (GtkScrollType)
import Gtk.Widget (Widget)
import Prelude (Unit, (<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type MenuProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkMenuProps Widget
    + GtkMenuShellProps
    +
      ( children ∷ Array MenuItem
      , onPopup ∷ Effect Unit
      , onMoveScroll ∷ EffectFn1 GtkScrollType Unit
      | r
      )

menu ∷ ∀ r r'. Union r r' (MenuProps ()) ⇒ Record r → Widget
menu = menuImpl <<< unsafeCoerce

foreign import menuImpl ∷ Record (MenuProps ()) → Widget

type UpdateMenuProps = Record (MenuProps ()) → Record (MenuProps ())

menu'
  ∷ ∀ r r'
  . Union r r' (MenuProps ())
  ⇒ Record r
  → Widget /\ (UpdateMenuProps → Effect Unit)
menu' props =
  let
    widget = menu props
    update = unsafeWidgetUpdate @(MenuProps ()) widget
  in
    widget /\ update


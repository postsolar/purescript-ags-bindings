module AGS.Widget.Menu
  ( MenuProps
  , menu
  , module AGS.Widget.Menu.Item
  ) where

import AGS.Widget.Menu.Item

import AGS.Widget.Internal (AGSWidgetProps)
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


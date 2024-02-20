module AGS.Widget.Menu
  ( MenuProps
  , menu
  , menu'
  , module AGS.Widget.Menu.Item
  ) where

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import AGS.Widget.Menu.Item (MenuItemProps, menuItem, menuItem')
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Gtk.Container (GtkContainerProps)
import Gtk.Menu (GtkMenuProps)
import Gtk.MenuShell (GtkMenuShellProps)
import Gtk.ScrollType (GtkScrollType)
import Gtk.Widget (Widget)
import Prelude (Unit, (<<<))
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type MenuProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkMenuProps Widget
    + GtkMenuShellProps
    +
      ( children ∷ ValueOrBinding (Array Widget)
      , onPopup ∷ ValueOrBinding (Effect Unit)
      , onMoveScroll ∷ ValueOrBinding (EffectFn1 GtkScrollType Unit)
      | r
      )

menu ∷ MkWidget (MenuProps ())
menu = menuImpl <<< unsafeCoerce <<< propsToValueOrBindings @(MenuProps ())

menu' ∷ MkWidgetWithUpdates (MenuProps ())
menu' = mkWidgetWithUpdates menu

foreign import menuImpl ∷ Record (MenuProps ()) → Widget


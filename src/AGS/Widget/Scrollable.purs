module AGS.Widget.Scrollable
  ( ScrollableProps
  , scrollable
  ) where

import Prelude

import AGS.Widget (AGSWidgetProps, Widget)
import Gtk.Container (GtkContainerProps)
import Gtk.ScrolledWindow (GtkScrolledWindowProps)
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type ScrollableProps r =
  AGSWidgetProps
    + GtkScrolledWindowProps
    + GtkContainerProps
    +
      ( hscroll ∷ String {- TODO make it a proper type -}
      , vscroll ∷ String {- TODO make it a proper type -}
      | r
      )

scrollable ∷ ∀ r r'. Union r r' (ScrollableProps ()) ⇒ Record r → Widget
scrollable = scrollableImpl <<< unsafeCoerce

foreign import scrollableImpl ∷ Record (ScrollableProps ()) → Widget


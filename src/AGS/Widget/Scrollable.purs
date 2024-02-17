module AGS.Widget.Scrollable
  ( ScrollableProps
  , UpdateScrollableProps
  , scrollable
  , scrollable'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Container (GtkContainerProps)
import Gtk.ScrolledWindow (GtkScrolledWindowProps)
import Gtk.Widget (Widget)
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

type UpdateScrollableProps =
  Record (ScrollableProps ()) → Record (ScrollableProps ())

scrollable'
  ∷ ∀ r r'
  . Union r r' (ScrollableProps ())
  ⇒ Record r
  → Widget /\ (UpdateScrollableProps → Effect Unit)
scrollable' props =
  let
    widget = scrollable props
    update = unsafeWidgetUpdate @(ScrollableProps ()) widget
  in
    widget /\ update


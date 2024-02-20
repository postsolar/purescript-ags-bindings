module AGS.Widget.Scrollable (ScrollableProps, scrollable, scrollable') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  )
import Gtk.Container (GtkContainerProps)
import Gtk.ScrolledWindow (GtkScrolledWindowProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type ScrollableProps r =
  AGSWidgetProps
    + GtkScrolledWindowProps
    + GtkContainerProps
    +
      ( hscroll ∷ ValueOrBinding String {- TODO make it a proper type -}
      , vscroll ∷ ValueOrBinding String {- TODO make it a proper type -}
      | r
      )

scrollable ∷ MkWidget (ScrollableProps ())
scrollable = scrollableImpl <<< unsafeCoerce

scrollable' ∷ MkWidgetWithUpdates (ScrollableProps ())
scrollable' = mkWidgetWithUpdates scrollable

foreign import scrollableImpl ∷ Record (ScrollableProps ()) → Widget


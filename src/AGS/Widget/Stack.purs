module AGS.Widget.Stack (StackProps, stack, stack') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Foreign.Object (Object)
import Gtk.Container (GtkContainerProps)
import Gtk.Stack (GtkStackProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type StackProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkStackProps Widget
    +
      ( children ∷ ValueOrBinding (Object Widget)
      , shown ∷ ValueOrBinding String
      | r
      )

stack ∷ MkWidget (StackProps ())
stack = stackImpl <<< unsafeCoerce <<< propsToValueOrBindings @(StackProps ())

stack' ∷ MkWidgetWithUpdates (StackProps ())
stack' = mkWidgetWithUpdates stack

foreign import stackImpl ∷ Record (StackProps ()) → Widget


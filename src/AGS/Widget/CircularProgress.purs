module AGS.Widget.CircularProgress
  ( CircularProgressProps
  , circularProgress
  , circularProgress'
  ) where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Container (GtkContainerProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type CircularProgressProps r =
  AGSWidgetProps
    + GtkContainerProps
    +
      ( startAt ∷ ValueOrBinding Number
      , endAt ∷ ValueOrBinding Number
      , inverted ∷ ValueOrBinding Boolean
      , rounded ∷ ValueOrBinding Boolean
      , value ∷ ValueOrBinding Number
      | r
      )

circularProgress ∷ MkWidget (CircularProgressProps ())
circularProgress = circularProgressImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(CircularProgressProps ())

circularProgress' ∷ MkWidgetWithUpdates (CircularProgressProps ())
circularProgress' = mkWidgetWithUpdates circularProgress

foreign import circularProgressImpl ∷ Record (CircularProgressProps ()) → Widget


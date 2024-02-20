module AGS.Widget.ProgressBar (ProgressBarProps, progressBar, progressBar') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Orientable (GtkOrientableProps)
import Gtk.ProgressBar (GtkProgressBarProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type ProgressBarProps r =
  AGSWidgetProps
    + GtkOrientableProps
    + GtkProgressBarProps
    +
      ( vertical ∷ ValueOrBinding Boolean
      , value ∷ ValueOrBinding Number
      | r
      )

progressBar ∷ MkWidget (ProgressBarProps ())
progressBar = progressBarImpl <<< unsafeCoerce <<< propsToValueOrBindings
  @(ProgressBarProps ())

progressBar' ∷ MkWidgetWithUpdates (ProgressBarProps ())
progressBar' = mkWidgetWithUpdates progressBar

foreign import progressBarImpl ∷ Record (ProgressBarProps ()) → Widget


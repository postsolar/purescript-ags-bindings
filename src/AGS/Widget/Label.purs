module AGS.Widget.Label (LabelProps, label, label') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Label (GtkLabelProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type LabelProps r =
  AGSWidgetProps
    + GtkLabelProps
    +
      ( justification ∷ ValueOrBinding String {- TODO make it a proper type -}
      , truncate ∷ ValueOrBinding String {- TODO make it a proper type -}
      | r
      )

label ∷ MkWidget (LabelProps ())
label = labelImpl <<< unsafeCoerce <<< propsToValueOrBindings @(LabelProps ())

label' ∷ MkWidgetWithUpdates (LabelProps ())
label' = mkWidgetWithUpdates label

foreign import labelImpl ∷ ∀ r. Record r → Widget


module AGS.Widget.CenterBox (CenterBoxProps, centerBox, centerBox') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Box (BoxProps)
import AGS.Widget.Internal
  ( MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Widget (Widget)
import Unsafe.Coerce (unsafeCoerce)

type CenterBoxProps r =
  BoxProps
    ( startWidget ∷ ValueOrBinding Widget
    , centerWidget ∷ ValueOrBinding Widget
    , endWidget ∷ ValueOrBinding Widget
    | r
    )

centerBox ∷ MkWidget (CenterBoxProps ())
centerBox = centerBoxImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(CenterBoxProps ())

centerBox' ∷ MkWidgetWithUpdates (CenterBoxProps ())
centerBox' = mkWidgetWithUpdates centerBox

foreign import centerBoxImpl ∷ Record (CenterBoxProps ()) → Widget


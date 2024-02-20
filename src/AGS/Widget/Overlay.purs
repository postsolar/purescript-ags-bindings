module AGS.Widget.Overlay (OverlayProps, overlay, overlay') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type OverlayProps r =
  AGSWidgetProps
    +
      ( child ∷ ValueOrBinding Widget
      , overlays ∷ ValueOrBinding (Array Widget)
      , passThrough ∷ ValueOrBinding Boolean
      | r
      )

overlay ∷ MkWidget (OverlayProps ())
overlay = overlayImpl <<< unsafeCoerce <<< propsToValueOrBindings
  @(OverlayProps ())

overlay' ∷ MkWidgetWithUpdates (OverlayProps ())
overlay' = mkWidgetWithUpdates overlay

foreign import overlayImpl ∷ Record (OverlayProps ()) → Widget


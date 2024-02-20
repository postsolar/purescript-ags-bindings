module AGS.Widget.EventBox (EventBoxProps, eventBox, eventBox') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Effect (Effect)
import Gtk.Container (GtkContainerProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type EventBoxProps r =
  AGSWidgetProps
    + GtkContainerProps
    +
      ( onPrimaryClick ∷ ValueOrBinding (Effect Unit)
      , onSecondaryClick ∷ ValueOrBinding (Effect Unit)
      , onMiddleClick ∷ ValueOrBinding (Effect Unit)
      , onPrimaryClickRelease ∷ ValueOrBinding (Effect Unit)
      , onSecondaryClickRelease ∷ ValueOrBinding (Effect Unit)
      , onMiddleClickRelease ∷ ValueOrBinding (Effect Unit)
      , onHover ∷ ValueOrBinding (Effect Unit)
      , onHoverLost ∷ ValueOrBinding (Effect Unit)
      , onScrollUp ∷ ValueOrBinding (Effect Unit)
      , onScrollDown ∷ ValueOrBinding (Effect Unit)
      | r
      )

eventBox ∷ MkWidget (EventBoxProps ())
eventBox = eventBoxImpl <<< unsafeCoerce <<< propsToValueOrBindings
  @(EventBoxProps ())

eventBox' ∷ MkWidgetWithUpdates (EventBoxProps ())
eventBox' = mkWidgetWithUpdates eventBox

foreign import eventBoxImpl ∷ Record (EventBoxProps ()) → Widget


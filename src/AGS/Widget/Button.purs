module AGS.Widget.Button (ButtonProps, button, button') where

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
import Gtk.Button (GtkButtonProps)
import Gtk.Container (GtkContainerProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type ButtonProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkButtonProps
    +
      ( child ∷ ValueOrBinding Widget
      , onClicked ∷ ValueOrBinding (Effect Unit)
      , onPrimaryClick ∷ ValueOrBinding (Effect Unit)
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

button ∷ MkWidget (ButtonProps ())
button = buttonImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(ButtonProps ())

button' ∷ MkWidgetWithUpdates (ButtonProps ())
button' = mkWidgetWithUpdates button

foreign import buttonImpl ∷ Record (ButtonProps ()) → Widget


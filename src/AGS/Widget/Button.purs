module AGS.Widget.Button where

import Prelude

import AGS.Widget (AGSWidgetProps, SelfOrBinding, Widget)
import Effect (Effect)
import Gtk.Button (GtkButtonProps)
import Gtk.Container (GtkContainerProps)
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type ButtonProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkButtonProps
    +
      ( child ∷ SelfOrBinding Widget
      , onClicked ∷ Effect Unit
      , onPrimaryClick ∷ Effect Unit
      , onSecondaryClick ∷ Effect Unit
      , onMiddleClick ∷ Effect Unit
      , onPrimaryClickRelease ∷ Effect Unit
      , onSecondaryClickRelease ∷ Effect Unit
      , onMiddleClickRelease ∷ Effect Unit
      , onHover ∷ Effect Unit
      , onHoverLost ∷ Effect Unit
      , onScrollUp ∷ Effect Unit
      , onScrollDown ∷ Effect Unit
      | r
      )

button ∷ ∀ r r'. Union r r' (ButtonProps ()) ⇒ Record r → Widget
button = buttonImpl <<< unsafeCoerce

foreign import buttonImpl ∷ Record (ButtonProps ()) → Widget


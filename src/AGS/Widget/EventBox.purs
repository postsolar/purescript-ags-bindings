module AGS.Widget.EventBox
  ( EventBoxProps
  , eventBox
  ) where

import Prelude

import Gtk.Widget (Widget)
import AGS.Widget.Internal (AGSWidgetProps)
import Effect (Effect)
import Gtk.Container (GtkContainerProps)
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type EventBoxProps r =
  AGSWidgetProps
    + GtkContainerProps
    +
      ( onPrimaryClick ∷ Effect Unit
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

eventBox
  ∷ ∀ r r'
  . Union r r' (EventBoxProps ())
  ⇒ Record r
  → Widget
eventBox = eventBoxImpl <<< unsafeCoerce

foreign import eventBoxImpl ∷ Record (EventBoxProps ()) → Widget


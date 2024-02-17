module AGS.Widget.EventBox
  ( EventBoxProps
  , UpdateEventBoxProps
  , eventBox
  , eventBox'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Container (GtkContainerProps)
import Gtk.Widget (Widget)
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

type UpdateEventBoxProps = Record (EventBoxProps ()) → Record (EventBoxProps ())

eventBox'
  ∷ ∀ r r'
  . Union r r' (EventBoxProps ())
  ⇒ Record r
  → Widget /\ (UpdateEventBoxProps → Effect Unit)
eventBox' props =
  let
    widget = eventBox props
    update = unsafeWidgetUpdate @(EventBoxProps ()) widget
  in
    widget /\ update


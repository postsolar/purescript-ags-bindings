module AGS.Widget.CircularProgress
  ( CircularProgressProps
  , UpdateCircularProgressProps
  , circularProgress
  , circularProgress'
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

type CircularProgressProps r =
  AGSWidgetProps
    + GtkContainerProps
    +
      ( startAt ∷ Number
      , endAt ∷ Number
      , inverted ∷ Boolean
      , rounded ∷ Boolean
      , value ∷ Number
      | r
      )

circularProgress
  ∷ ∀ r r'. Union r r' (CircularProgressProps ()) ⇒ Record r → Widget
circularProgress = circularProgressImpl <<< unsafeCoerce

foreign import circularProgressImpl ∷ Record (CircularProgressProps ()) → Widget

type UpdateCircularProgressProps =
  Record (CircularProgressProps ()) → Record (CircularProgressProps ())

circularProgress'
  ∷ ∀ r r'
  . Union r r' (CircularProgressProps ())
  ⇒ Record r
  → Widget /\ (UpdateCircularProgressProps → Effect Unit)
circularProgress' props =
  let
    widget = circularProgress props
    update = unsafeWidgetUpdate @(CircularProgressProps ()) widget
  in
    widget /\ update


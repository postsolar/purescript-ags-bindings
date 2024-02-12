module AGS.Widget.CircularProgress
  ( CircularProgressProps
  , circularProgress
  ) where

import AGS.Widget (AGSWidgetProps, Widget)
import Gtk.Container (GtkContainerProps)
import Prelude ((<<<))
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


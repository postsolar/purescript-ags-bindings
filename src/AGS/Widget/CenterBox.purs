module AGS.Widget.CenterBox
  ( CenterBoxProps
  , centerBox
  ) where

import AGS.Binding (SelfOrBinding)
import AGS.Widget.Box (BoxProps)
import Gtk.Widget (Widget)
import Prelude ((<<<))
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

type CenterBoxProps r =
  BoxProps
    ( startWidget ∷ SelfOrBinding Widget
    , centerWidget ∷ SelfOrBinding Widget
    , endWidget ∷ SelfOrBinding Widget
    | r
    )

centerBox
  ∷ ∀ r r'
  . Union r r' (CenterBoxProps ())
  ⇒ Record r
  → Widget
centerBox = centerBoxImpl <<< unsafeCoerce

foreign import centerBoxImpl ∷ Record (CenterBoxProps ()) → Widget


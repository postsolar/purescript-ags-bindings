module AGS.Widget.Window (WindowProps, Window, window) where

import Prelude

import AGS.Widget (SelfOrBinding, Widget)
import AGS.Widget.Window.Anchor as Anchor
import AGS.Widget.Window.Exclusivity as Exclusivity
import AGS.Widget.Window.Layer as WindowLayer
import Effect (Effect)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

type WindowProps =
  ( name ∷ String
  , child ∷ SelfOrBinding Widget
  , anchor ∷ Array Anchor.Anchor
  , layer ∷ WindowLayer.WindowLayer
  , exclusivity ∷ Exclusivity.Exclusivity
  , keymode ∷ String
  , popup ∷ Boolean
  , visible ∷ Boolean
  )

foreign import data Window ∷ Type

window
  ∷ ∀ r r'
  . Union r r' WindowProps
  ⇒ Record r
  → Effect Window
window = windowImpl <<< unsafeCoerce

foreign import windowImpl ∷ Record WindowProps → Effect Window


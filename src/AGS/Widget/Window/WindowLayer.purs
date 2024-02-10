module AGS.Widget.Window.Layer where

import Unsafe.Coerce (unsafeCoerce)

foreign import data WindowLayer ∷ Type

overlay ∷ WindowLayer
overlay = unsafeCoerce "overlay"

top ∷ WindowLayer
top = unsafeCoerce "top"

bottom ∷ WindowLayer
bottom = unsafeCoerce "bottom"

background ∷ WindowLayer
background = unsafeCoerce "background"


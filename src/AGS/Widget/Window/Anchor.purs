module AGS.Widget.Window.Anchor where

import Unsafe.Coerce (unsafeCoerce)

foreign import data Anchor ∷ Type

top ∷ Anchor
top = unsafeCoerce "top"

right ∷ Anchor
right = unsafeCoerce "right"

bottom ∷ Anchor
bottom = unsafeCoerce "bottom"

left ∷ Anchor
left = unsafeCoerce "left"

all ∷ Array Anchor
all = [ top, right, bottom, left ]


module AGS.Widget.Window.Exclusivity where

import Unsafe.Coerce (unsafeCoerce)

foreign import data Exclusivity ∷ Type

exclusive ∷ Exclusivity
exclusive = unsafeCoerce "exclusive"

normal ∷ Exclusivity
normal = unsafeCoerce "normal"

ignore ∷ Exclusivity
ignore = unsafeCoerce "ignore"


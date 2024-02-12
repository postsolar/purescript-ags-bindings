module AGS.Utils.File where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Gio.File (GioFile)
import Promise.Aff (Promise, toAffE)

class FileLike ∷ Type → Constraint
class FileLike f

instance FileLike String
instance FileLike GioFile

readFile ∷ ∀ f. FileLike f ⇒ f → Effect String
readFile = readFileImpl

readFileAsync ∷ ∀ f. FileLike f ⇒ f → Aff String
readFileAsync = toAffE <<< readFileAsyncImpl

foreign import readFileImpl ∷ ∀ a. a → Effect String
foreign import readFileAsyncImpl ∷ ∀ a. a → Effect (Promise String)


module AGS.Utils.File where

import Effect.Uncurried
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
readFile = runEffectFn1 readFileImpl

readFileAsync ∷ ∀ f. FileLike f ⇒ f → Aff String
readFileAsync = toAffE <<< runEffectFn1 readFileAsyncImpl

foreign import readFileImpl ∷ ∀ a. EffectFn1 a String
foreign import readFileAsyncImpl ∷ ∀ a. EffectFn1 a (Promise String)

writeFile ∷ { content ∷ String, path ∷ String } → Aff GioFile
writeFile { content, path } = toAffE (runEffectFn2 writeFileImpl content path)

writeFileSync ∷ { content ∷ String, path ∷ String } → Effect GioFile
writeFileSync { content, path } = runEffectFn2 writeFileSyncImpl content path

foreign import writeFileImpl ∷ EffectFn2 String String (Promise GioFile)
foreign import writeFileSyncImpl ∷ EffectFn2 String String GioFile


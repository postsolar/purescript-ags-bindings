module AGS.Utils.File where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Gio.File (GioFile)
import Promise.Aff (Promise, toAffE)

-- TODO: add primitives for `Gio.File` and write these in PureScript

-- | Read a file synchronously.
readFile ∷ GioFile → Effect String
readFile = runEffectFn1 readFileImpl

-- | Read a file asynchronously.
readFileAsync ∷ GioFile → Aff String
readFileAsync = toAffE <<< runEffectFn1 readFileAsyncImpl

foreign import readFileImpl ∷ ∀ a. EffectFn1 a String
foreign import readFileAsyncImpl ∷ ∀ a. EffectFn1 a (Promise String)

-- | Write to a file asynchronously, replacing old contents.
writeFile ∷ String → GioFile → Aff GioFile
writeFile content file = toAffE (runEffectFn2 writeFileImpl content file)

-- | Write to a file synchronously, replacing old contents.
writeFileSync ∷ String → GioFile → Effect GioFile
writeFileSync = runEffectFn2 writeFileSyncImpl

foreign import writeFileImpl ∷ EffectFn2 String GioFile (Promise GioFile)
foreign import writeFileSyncImpl ∷ EffectFn2 String GioFile GioFile


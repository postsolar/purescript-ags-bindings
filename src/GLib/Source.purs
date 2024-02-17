module GLib.Source
  ( GLibSource
  , SourceID
  , destroy
  , sourceRemove
  ) where

import Prelude

import Effect (Effect)

-- Some functions return GLib.Source, whereas some return a
-- simple `number`. Still we'd like both to be typed.
foreign import data GLibSource ∷ Type
foreign import data SourceID ∷ Type

foreign import destroy ∷ GLibSource → Effect Unit

foreign import sourceRemove ∷ SourceID → Effect Unit


module GLib.Bytes where

import Data.ArrayBuffer.Types (Uint8Array)

foreign import data Bytes ∷ Type

foreign import fromString ∷ String → Bytes
foreign import fromUint8Array ∷ Uint8Array → Bytes
foreign import toUint8Array ∷ Bytes → Uint8Array


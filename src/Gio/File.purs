module Gio.File
  ( fromPath
  , fromURI
  , createAsync
  , replaceContentsBytesAsync
  , loadContents
  , loadContentsAsync
  , makeDirectorySync
  , makeDirectoryAsync
  , makeDirectoryRecursive
  , GioFile
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Aff (Aff)
import GLib.Bytes as GLib.Bytes
import GLib.Priority as GLib.Priority
import Gio.FileCreateFlags (GioFileCreateFlags)
import Gio.FileOutputStream (GioFileOutputStream)
import Promise.Aff (Promise, toAffE)

foreign import data GioFile ∷ Type

-- * Constructors

-- | Create a GioFile from a string containing a file path.
foreign import fromPath ∷ String → GioFile

-- | Create a GioFile from a string containing a URI.
foreign import fromURI ∷ String → GioFile

-- * Writing or creating

-- | Create a new file asynchronously.
createAsync
  ∷ GioFileCreateFlags
  → GLib.Priority.Priority
  → GioFile
  → Aff (Nullable GioFileOutputStream)
createAsync flags priority file = toAffE (createAsyncImpl flags priority file)

foreign import createAsyncImpl
  ∷ GioFileCreateFlags
  → GLib.Priority.Priority
  → GioFile
  → Effect (Promise (Nullable GioFileOutputStream))

-- | Replace the contents of a given file (creating the file if necessary).
replaceContentsBytesAsync
  ∷ ∀ r
  . { content ∷ GLib.Bytes.Bytes
    , file ∷ GioFile
    , flags ∷ GioFileCreateFlags
    , makeBackup ∷ Boolean
    | r
    }
  → Aff Unit
replaceContentsBytesAsync { makeBackup, flags, content, file } =
  toAffE (replaceContentsBytesAsyncImpl makeBackup flags content file)

foreign import replaceContentsBytesAsyncImpl
  ∷ Boolean
  → GioFileCreateFlags
  → GLib.Bytes.Bytes
  → GioFile
  → Effect (Promise Unit)

-- * Reading

-- | Load the contents of a file synchronously.
foreign import loadContents
  ∷ GioFile
  → Effect Uint8Array

-- | Load the contents of a file asynchronously.
loadContentsAsync ∷ GioFile → Aff Uint8Array
loadContentsAsync = toAffE <<< loadContentsAsyncImpl

foreign import loadContentsAsyncImpl
  ∷ GioFile → Effect (Promise Uint8Array)

-- * Directories

-- | Synchronously make a directory for a given file path.
-- | NOTE: recursive directory creation is not supported.
foreign import makeDirectorySync ∷ GioFile → Effect Unit

-- | Asynchronously make a directory for a given file path.
-- | NOTE: recursive directory creation is not supported.
makeDirectoryAsync ∷ GLib.Priority.Priority → GioFile → Aff Boolean
makeDirectoryAsync priority path = toAffE (makeDirectoryAsyncImpl priority path)

foreign import makeDirectoryAsyncImpl
  ∷ GLib.Priority.Priority → GioFile → Effect (Promise Boolean)

-- | Synchronously make a directory for a given file path, recursively.
foreign import makeDirectoryRecursive ∷ GioFile → Effect Boolean


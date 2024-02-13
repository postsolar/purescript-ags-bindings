module Gio.FileOutputStream where

import Effect (Effect)
import Effect.Aff (Aff)
import GLib.Bytes as GLib.Bytes
import GLib.Priority as GLib.Priority
import Promise.Aff (Promise, toAffE)

-- TODO:
-- FileOutputStream extends OutputStream, which hasn't been written yet
-- https://gjs-docs.gnome.org/gio20~2.0/gio.outputstream

foreign import data GioFileOutputStream ∷ Type

-- | Write bytes to an output stream asynchronously.
-- | Returns the number of bytes written.
writeBytesAsync
  ∷ GLib.Priority.Priority → GLib.Bytes.Bytes → GioFileOutputStream → Aff Int
writeBytesAsync priority bytes fos = toAffE
  (writeBytesAsyncImpl priority bytes fos)

foreign import writeBytesAsyncImpl
  ∷ GLib.Priority.Priority
  → GLib.Bytes.Bytes
  → GioFileOutputStream
  → Effect (Promise Int)


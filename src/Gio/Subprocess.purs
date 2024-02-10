module Gio.Subprocess where

import Data.Unit (Unit)
import Effect (Effect)

-- https://gjs-docs.gnome.org/gio20~2.0/gio.subprocess
foreign import data Subprocess ∷ Type

foreign import forceSubprocessExit ∷ Subprocess → Effect Unit


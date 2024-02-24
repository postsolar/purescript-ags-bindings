module Gtk.IconInfo (GtkIconInfo, filename) where

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Prelude ((<<<))

foreign import data GtkIconInfo ∷ Type

-- | Returns the full path to the icon, unless it's a builtin icon.
filename ∷ GtkIconInfo → Maybe String
filename = toMaybe <<< getFilenameImpl

foreign import getFilenameImpl ∷ GtkIconInfo → Nullable String


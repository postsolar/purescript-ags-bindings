module AGS.Utils.Icon (lookupIcon) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Gtk.IconInfo (GtkIconInfo)

-- | Look up an icon given its name and size.
lookupIcon ∷ String → Int → Effect (Maybe GtkIconInfo)
lookupIcon name size = map toMaybe (runEffectFn2 lookupIconImpl name size)

foreign import lookupIconImpl ∷ EffectFn2 String Int (Nullable GtkIconInfo)


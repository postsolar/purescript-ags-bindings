module GLib.Timeout
  ( timeoutAdd
  , module GLib.Source
  ) where

import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn3, runEffectFn3)
import GLib.Priority (Priority)
import GLib.Source (SourceID, sourceRemove)

-- | Add a timer which will execute an effect as long as
-- | this effect does not return `false`. The timer can be
-- | manually cancelled with `GLib.Source.sourceRemove`.
-- | https://gjs-docs.gnome.org/glib20~2.0/glib.timeout_add
timeoutAdd ∷ Priority → Milliseconds → Effect Boolean → Effect SourceID
timeoutAdd = runEffectFn3 timeoutAddImpl

foreign import timeoutAddImpl
  ∷ EffectFn3
      Priority
      Milliseconds
      (Effect Boolean)
      SourceID


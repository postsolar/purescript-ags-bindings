module GJS.Timer
  ( setTimeout
  , setInterval
  , module GLib.Source
  ) where

import Prelude

import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import GLib.Source (GLibSource, destroy)

-- | Execute an effect after a given number of milliseconds.
-- | A timer set by this function can be cancelled using `GLib.Source.destroy`.
setTimeout ∷ Milliseconds → Effect Unit → Effect GLibSource
setTimeout = flip (runEffectFn2 setTimeoutImpl)

-- | Execute an effect periodically with an interval of a given number of milliseconds.
-- | A timer set by this function can be cancelled using `GLib.Source.destroy`.
setInterval ∷ Milliseconds → Effect Unit → Effect GLibSource
setInterval = flip (runEffectFn2 setIntervalImpl)

foreign import setTimeoutImpl ∷ EffectFn2 (Effect Unit) Milliseconds GLibSource
foreign import setIntervalImpl ∷ EffectFn2 (Effect Unit) Milliseconds GLibSource


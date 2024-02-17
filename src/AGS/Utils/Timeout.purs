module AGS.Utils.Timeout
  ( interval
  , timeout
  , module GLib.Source
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn3, runEffectFn3)
import GLib.Priority (default)
import GLib.Source (SourceID, sourceRemove)
import GLib.Timeout (timeoutAdd)
import Gtk.Widget (Widget)
import Untagged.Union (UndefinedOr, maybeToUor)

-- TODO: reimplement in PureScript
-- Currently the blocker is the lack of `widget.connect('destroy')`
interval ∷ Milliseconds → Maybe Widget → Effect Unit → Effect SourceID
interval ms widget ef = runEffectFn3 intervalImpl ms ef (maybeToUor widget)

foreign import intervalImpl
  ∷ EffectFn3
      Milliseconds
      (Effect Unit)
      (UndefinedOr Widget)
      SourceID

timeout ∷ ∀ a. Milliseconds → Effect a → Effect SourceID
timeout ms ef = timeoutAdd default ms (ef $> false)


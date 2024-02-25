module GObject
  ( HandlerID
  , class GObjectSignal
  , overrides
  , connect
  , disconnect
  , unsafeCopyGObjectProps
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Variant (Variant)
import Data.Variant as V
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn3, runEffectFn2, runEffectFn3)
import Partial.Unsafe (unsafeCrashWith)
import Prim.Row as R
import Record.Studio.Keys (class Keys, keys)
import Type.Proxy (Proxy(..))

foreign import data HandlerID ∷ ∀ k. k → Type

-- | This class establishes how different GObjects should connect to signals.
-- | The first type parameter lays out the user-facing callback types, and
-- | the second type parameter lays out the types used by GJS runtime.
-- | An instance could look as follows:
-- |
-- | ```purescript
-- | foreign import data Object1 ∷ Type -- the GObject
-- | type Signals = ( changed ∷ EffectFn2 Object1 Int Unit )
-- | -- don't apply any overrides
-- | instance GObjectSignal Object1 Signals Signals where
-- |   overrides = V.over {}
-- |
-- | -- now the same, but with overrides
-- | foreign import data Object2 ∷ Type
-- | type Signals = ( changed ∷ Effect Unit )
-- | type SignalOverrides = ( changed ∷ EffectFn2 Object2 String Unit )
-- | instance GObjectSignal Object2 Signals SignalOverrides where
-- |   overrides = V.over { changed: \cb → mkEffectFn2 \_ _ → cb }
-- | ```
-- |
-- | *Note*: for an instance to be found, a type alias used in the
-- | instance head must be exported.
class GObjectSignal ∷ Type → Row Type → Row Type → Constraint
class
  GObjectSignal object signals overrides
  | object → signals overrides
  where
  overrides ∷ Variant signals → Variant overrides

-- | Connect a GObject to a signal.
-- | Example:
-- |
-- | ```purescript
-- | connect @"changed" myObject \_obj info → log info
-- | ```
connect
  ∷ ∀ @sig @obj cb pcb rt rt' os ovs
  . R.Cons sig cb rt os
  -- This constraint aids the compiler find the type of
  -- the processed callback to project the variant's value.
  -- It shouldn't be removed.
  ⇒ R.Cons sig pcb rt' ovs
  ⇒ GObjectSignal obj os ovs
  ⇒ IsSymbol sig
  ⇒ obj
  → cb
  → Effect (HandlerID obj)
connect o cb' =
  V.inj label cb'
    # overrides @obj @os
    # V.prj label
    # case _ of
        Just cb → runEffectFn3 connectImpl (reflectSymbol label) o cb
        Nothing → unsafeCrashWith "connect: impossible"

  where
  label = Proxy @sig

foreign import connectImpl ∷ ∀ f o. EffectFn3 String o f (HandlerID o)

-- | Disconnect a GObject given its HandlerID.
disconnect
  ∷ ∀ @obj os ovs. GObjectSignal obj os ovs ⇒ obj → HandlerID obj → Effect Unit
disconnect = runEffectFn2 disconnectImpl

foreign import disconnectImpl ∷ ∀ o. EffectFn2 o (HandlerID o) Unit

-- | Copy a set of properties from a given GObject.
unsafeCopyGObjectProps ∷ ∀ @props o. Keys props ⇒ o → Record props
unsafeCopyGObjectProps = unsafeCopyGObjectImpl (keys (Proxy @props))

foreign import unsafeCopyGObjectImpl
  ∷ ∀ props o. Array String → o → Record props


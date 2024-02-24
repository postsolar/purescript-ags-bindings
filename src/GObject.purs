module GObject
  ( HandlerID
  , class GObjectSignal
  , connect
  , disconnect
  , unsafeCopyGObjectProps
  ) where

import Prelude

import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn3, runEffectFn2, runEffectFn3)
import Prim.Row as R
import Record.Studio.Keys (class Keys, keys)
import Type.Proxy (Proxy(..))

foreign import data HandlerID ∷ ∀ k. k → Type

class GObjectSignal ∷ Type → Row Type → Constraint
class GObjectSignal object signals | object → signals

connect
  ∷ ∀ @sig @obj cb rt os
  . R.Cons sig cb rt os
  ⇒ GObjectSignal obj os
  ⇒ IsSymbol sig
  ⇒ obj
  → cb
  → Effect (HandlerID obj)
connect = runEffectFn3 connectImpl (reflectSymbol (Proxy @sig))

foreign import connectImpl ∷ ∀ f o. EffectFn3 String o f (HandlerID o)

-- | Disconnect a GObject given its HandlerID.
disconnect ∷ ∀ @obj os. GObjectSignal obj os ⇒ obj → HandlerID obj → Effect Unit
disconnect = runEffectFn2 disconnectImpl

foreign import disconnectImpl ∷ ∀ o. EffectFn2 o (HandlerID o) Unit

-- | Copy a set of properties from a given GObject.
unsafeCopyGObjectProps ∷ ∀ @props o. Keys props ⇒ o → Record props
unsafeCopyGObjectProps = unsafeCopyGObjectImpl (keys (Proxy @props))

foreign import unsafeCopyGObjectImpl
  ∷ ∀ props o. Array String → o → Record props


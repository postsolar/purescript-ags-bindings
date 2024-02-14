module GObject
  ( class GObjectSignal
  , class SignalCallback
  , HandlerID
  , connect
  , unsafeConnect
  , disconnect
  ) where

import Prelude

import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Uncurried
  ( EffectFn1
  , EffectFn10
  , EffectFn2
  , EffectFn3
  , EffectFn4
  , EffectFn5
  , EffectFn6
  , EffectFn7
  , EffectFn8
  , EffectFn9
  , runEffectFn2
  , runEffectFn3
  )
import Prim.TypeError as TE
import Type.Proxy (Proxy(..))

foreign import data HandlerID ∷ ∀ k. k → Type

class SignalCallback ∷ Type → Type → Constraint
class SignalCallback o f

instance SignalCallback o (EffectFn1 o Unit)
else instance SignalCallback o (EffectFn2 o b Unit)
else instance SignalCallback o (EffectFn3 o b c Unit)
else instance SignalCallback o (EffectFn4 o b c d Unit)
else instance SignalCallback o (EffectFn5 o b c d e Unit)
else instance SignalCallback o (EffectFn6 o b c d e f Unit)
else instance SignalCallback o (EffectFn7 o b c d e f g Unit)
else instance SignalCallback o (EffectFn8 o b c d e f g h Unit)
else instance SignalCallback o (EffectFn9 o b c d e f g h i Unit)
else instance SignalCallback o (EffectFn10 o b c d e f g h i j Unit)
else instance
  TE.Fail (TE.Text "Only EffectFnN with GObject as the first parameter can have a SignalCallback instance") ⇒
  SignalCallback o other

class GObjectSignal ∷ ∀ k. k → Type → Type → Constraint
class SignalCallback o f ⇐ GObjectSignal s o f | o s → f where
  connect ∷ f → o → Effect (HandlerID o)

-- This is called unsafe because its purpose is to simplify defining class instances.
-- When it's used in the instance definition, type checking is essentially turned off.
-- The upside is that we don't have to import a separate `connectImpl` for each single module.
unsafeConnect
  ∷ ∀ @s @o @f
  . IsSymbol s
  ⇒ SignalCallback o f
  ⇒ GObjectSignal s o f
  ⇒ f
  → o
  → Effect (HandlerID o)
unsafeConnect = runEffectFn3 connectImpl (reflectSymbol (Proxy @s))

foreign import connectImpl ∷ ∀ f o. EffectFn3 String f o (HandlerID o)

-- | Disconnect a GObject given its HandlerID.
disconnect ∷ ∀ @s @o @f. GObjectSignal s o f ⇒ o → HandlerID o → Effect Unit
disconnect = runEffectFn2 disconnectImpl

foreign import disconnectImpl ∷ ∀ o. EffectFn2 o (HandlerID o) Unit


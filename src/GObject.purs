module GObject
  ( class EffectFnAnyArity
  , class GObject
  , class ToSignal
  , HandlerID
  , Changed(..)
  , SignalHandler
  , SignalHandlerF
  , connect
  , disconnect
  , mkSignalHandler
  , toSignal
  , withSignal
  ) where

import Prelude

import Data.Exists (Exists, mkExists)
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
  )

foreign import data HandlerID ∷ Type

class GObject ∷ ∀ k. k → Constraint
class GObject o

class EffectFnAnyArity ∷ Type → Constraint
class EffectFnAnyArity f

instance EffectFnAnyArity (Effect a)
instance EffectFnAnyArity (EffectFn1 a b)
instance EffectFnAnyArity (EffectFn2 a b c)
instance EffectFnAnyArity (EffectFn3 a b c d)
instance EffectFnAnyArity (EffectFn4 a b c d e)
instance EffectFnAnyArity (EffectFn5 a b c d e f)
instance EffectFnAnyArity (EffectFn6 a b c d e f g)
instance EffectFnAnyArity (EffectFn7 a b c d e f g h)
instance EffectFnAnyArity (EffectFn8 a b c d e f g h i)
instance EffectFnAnyArity (EffectFn9 a b c d e f g h i j)
instance EffectFnAnyArity (EffectFn10 a b c d e f g h i j k)

newtype SignalHandlerF f = SignalHandlerF f

type SignalHandler = Exists SignalHandlerF

-- | Obtain a `SignalHandler` given an `EffectFnN` (any arity).
mkSignalHandler ∷ ∀ f. EffectFnAnyArity f ⇒ f → SignalHandler
mkSignalHandler = mkExists <<< SignalHandlerF

class ToSignal s where
  toSignal
    ∷ s
    → { handler ∷ SignalHandler
      , signal ∷ String
      }

-- | Apply the handler and the signal to a given function.
withSignal ∷ ∀ s a. ToSignal s ⇒ (SignalHandler → String → a) → s → a
withSignal f s = f handler signal
  where
  { handler, signal } = toSignal s

-- | A generic `changed` signal.
data Changed = Changed (Effect Unit)

instance ToSignal Changed where
  toSignal (Changed f) =
    { handler: mkSignalHandler f
    , signal: "changed"
    }

-- | Connect a GObject given a signal.
connect ∷ ∀ s o. ToSignal s ⇒ GObject o ⇒ s → o → Effect HandlerID
connect = withSignal connectImpl

foreign import connectImpl
  ∷ ∀ o. SignalHandler → String → o → Effect HandlerID

-- | Disconnects a GObject given its HandlerID.
disconnect ∷ ∀ o. GObject o ⇒ o → HandlerID → Effect Unit
disconnect = disconnectImpl

foreign import disconnectImpl ∷ ∀ o. o → HandlerID → Effect Unit


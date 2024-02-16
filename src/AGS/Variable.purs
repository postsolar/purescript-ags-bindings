module AGS.Variable
  ( Variable
  , get
  , set
  , bindValue
  , store
  , poll
  , serve
  , listen
  ) where

import Prelude

import AGS.Binding (Binding)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import GObject (class GObjectSignal, unsafeConnect)

foreign import data Variable ∷ Type → Type

instance GObjectSignal "changed" (Variable a) (EffectFn1 (Variable a) Unit) where
  connect callback variable = unsafeConnect @"changed" callback variable

-- | Get the value of a variable.
foreign import get ∷ ∀ a. Variable a → Effect a

-- | Update the value of a variable.
foreign import set ∷ ∀ a. (a → a) → Variable a → Effect Unit

-- | Bind the value of a variable.
foreign import bindValue ∷ ∀ a. Variable a → Binding a

-- | Create a variable.
foreign import store ∷ ∀ a. a → Variable a

-- | Create a variable which would periodically run an external command.
foreign import poll
  ∷ ∀ a
  . { initValue ∷ a
    , interval ∷ Int
    , transform ∷ String → a
    , command ∷ Array String
    }
  → Effect (Variable a)

-- | Create a variable which would periodically run an effectful action.
foreign import serve
  ∷ ∀ a
  . { initValue ∷ a
    , interval ∷ Int
    , command ∷ Effect a
    }
  → Effect (Variable a)

-- | Create a variable which would listen to the output of a command.
foreign import listen
  ∷ ∀ a
  . { initValue ∷ a
    , command ∷ Array String
    , transform ∷ a → String → a
    }
  → Effect (Variable a)


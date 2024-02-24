module AGS.Variable
  ( Variable
  , VariableSignals
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
import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import GObject (class GObjectSignal)

foreign import data Variable ∷ Type → Type

type VariableSignals a =
  ( changed ∷ EffectFn1 (Variable a) Unit
  )

instance GObjectSignal (Variable a) (VariableSignals a)

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
    , interval ∷ Milliseconds
    , transform ∷ String → a
    , command ∷ Array String
    }
  → Effect (Variable a)

-- | Create a variable which would periodically run an effectful action.
foreign import serve
  ∷ ∀ a
  . { initValue ∷ a
    , interval ∷ Milliseconds
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


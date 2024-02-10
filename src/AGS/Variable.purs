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
import GObject (class GObject)
import Unsafe.Coerce (unsafeCoerce)

foreign import data Variable ∷ Type → Type

instance GObject (Variable a)

-- | Get the value of a variable
get ∷ ∀ a. Variable a → Effect a
get = unsafeCoerce _.getValue

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


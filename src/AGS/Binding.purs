module AGS.Binding
  ( Binding
  , SelfOrBinding
  , class BindProp
  , bindProp
  , unsafeBindProp
  ) where

import Prelude

import Control.Apply (lift2)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Type.Proxy (Proxy(..))
import Untagged.Union (OneOf)

foreign import data Binding ∷ Type → Type

type role Binding representational

type SelfOrBinding a = OneOf a (Binding a)

class BindProp ∷ ∀ k. Type → k → Type → Constraint
class BindProp o p t | o p → t where
  bindProp ∷ o → Binding t

unsafeBindProp ∷ ∀ @p @o @t. IsSymbol p ⇒ BindProp o p t ⇒ o → Binding t
unsafeBindProp = unsafeBindPropImpl (reflectSymbol (Proxy @p))

foreign import unsafeBindPropImpl ∷ ∀ o t. String → o → Binding t

-- | Transform the value streamed in a `Binding`.
instance Functor Binding where
  map = transform

-- | Combine multiple `Binding`s together.
-- | A `Binding` produced with this instance will be updated whenever
-- | *either* of the original bindings changes.
instance Apply Binding where
  -- Not derived from `bind` via `ap` because `applyBinding`
  -- probably has better implementation
  apply = applyBinding

instance Applicative Binding where
  pure = pureBinding

-- | Combine multiple `Binding`s together sequentially.
-- | A `Binding` produced with this instance will be updated whenever
-- | *either* of the original bindings changes.
instance Bind Binding where
  bind = bindBinding

instance Monad Binding

instance Semigroup a ⇒ Semigroup (Binding a) where
  append = lift2 append

instance Monoid a ⇒ Monoid (Binding a) where
  mempty = pure mempty

foreign import transform ∷ ∀ a b. (a → b) → Binding a → Binding b
foreign import applyBinding ∷ ∀ a b. Binding (a → b) → Binding a → Binding b
foreign import pureBinding ∷ ∀ a. a → Binding a
foreign import bindBinding ∷ ∀ a b. Binding a → (a → Binding b) → Binding b


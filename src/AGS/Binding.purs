module AGS.Binding
  ( Binding
  , class BindProp
  , bindProp
  , ValueOrBinding
  , overValue
  , overBinding
  , overBoth
  ) where

import Prelude

import Control.Apply (lift2)
import Data.Either (either)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Prim.Row as R
import Type.Proxy (Proxy(..))
import Untagged.TypeCheck (class HasRuntimeType)
import Untagged.Union (OneOf, asOneOf, toEither1)

foreign import data Binding ∷ Type → Type

type role Binding representational

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

class BindProp ∷ Type → Row Type → Constraint
class BindProp object props | object → props

bindProp
  ∷ ∀ @prop @obj ty props rt
  . R.Cons prop ty rt props
  ⇒ IsSymbol prop
  ⇒ BindProp obj props
  ⇒ obj
  → Binding ty
bindProp = unsafeBindProp (reflectSymbol (Proxy @prop))

foreign import unsafeBindProp ∷ ∀ o t. String → o → Binding t

-- * ValueOrBinding

type ValueOrBinding a = OneOf a (Binding a)

-- | Transform a *value* inside a `ValueOrBinding`.
-- | If `ValueOrBinding` is a binding, it stays unmodified.
overValue
  ∷ ∀ a
  . HasRuntimeType a
  ⇒ (a → a)
  → ValueOrBinding a
  → ValueOrBinding a
overValue = flip overBoth identity

-- | Transform a *binding* inside a `ValueOrBinding`.
-- | If `ValueOrBinding` is a plain value, it stays unmodified.
overBinding
  ∷ ∀ a
  . HasRuntimeType a
  ⇒ (Binding a → Binding a)
  → ValueOrBinding a
  → ValueOrBinding a
overBinding = overBoth identity

-- | Transform both a plain value and a binding in `ValueOrBinding`.
overBoth
  ∷ ∀ a b
  . HasRuntimeType a
  ⇒ (a → b)
  → (Binding a → Binding b)
  → ValueOrBinding a
  → ValueOrBinding b
overBoth f g sob = either (asOneOf <<< f) (asOneOf <<< g) $ toEither1 sob


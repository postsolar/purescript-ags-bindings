module AGS.Binding (Binding, SelfOrBinding) where

import Prelude

import Control.Apply (lift2)
import Untagged.Union (OneOf)

foreign import data Binding ∷ Type → Type

type SelfOrBinding a = OneOf a (Binding a)

instance Functor Binding where
  map = transform

instance Apply Binding where
  apply = ap

instance Applicative Binding where
  pure = pureBinding

instance Bind Binding where
  bind = bindBinding

instance Monad Binding

instance Semigroup a ⇒ Semigroup (Binding a) where
  append = lift2 append

instance Monoid a ⇒ Monoid (Binding a) where
  mempty = pure mempty

foreign import transform ∷ ∀ a b. (a → b) → Binding a → Binding b
foreign import pureBinding ∷ ∀ a. a → Binding a
foreign import bindBinding ∷ ∀ a b. Binding a → (a → Binding b) → Binding b


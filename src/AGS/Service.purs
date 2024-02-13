module AGS.Service where

import AGS.Binding (Binding)
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
import GObject (HandlerID)
import Prelude (Unit)
import Prim.TypeError as TE

data Service

class BindServiceProp ∷ ∀ k. Service → k → Type → Constraint
class BindServiceProp s p a | s p → a where
  bindServiceProp ∷ Effect (Binding a)

class ServiceCallback ∷ Type → Constraint
class ServiceCallback f

instance ServiceCallback (Effect Unit)
else instance ServiceCallback (EffectFn1 a Unit)
else instance ServiceCallback (EffectFn2 a b Unit)
else instance ServiceCallback (EffectFn3 a b c Unit)
else instance ServiceCallback (EffectFn4 a b c d Unit)
else instance ServiceCallback (EffectFn5 a b c d e Unit)
else instance ServiceCallback (EffectFn6 a b c d e f Unit)
else instance ServiceCallback (EffectFn7 a b c d e f g Unit)
else instance ServiceCallback (EffectFn8 a b c d e f g h Unit)
else instance ServiceCallback (EffectFn9 a b c d e f g h i Unit)
else instance ServiceCallback (EffectFn10 a b c d e f g h i j Unit)
else instance
  TE.Fail (TE.Text "Only EffectFnN can have a ServiceCallback instance") ⇒
  ServiceCallback other

-- This class mimics `GObjectSignal` but allows the instances
-- to not expose the service object and wrap the callbacks so
-- that the object doesn't get passed to them. The former is simply
-- redundant because the object is known statically, the latter
-- is usually highly unsafe due to services representing mutable objects.
class ServiceConnect ∷ ∀ k. Service → k → Type → Constraint
class
  ServiceCallback callback ⇐
  ServiceConnect service signal callback
  | service signal → callback where
  connectService ∷ callback → Effect (HandlerID service)


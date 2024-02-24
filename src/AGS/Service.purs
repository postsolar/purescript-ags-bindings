module AGS.Service where

import AGS.Binding (Binding)
import Effect (Effect)
import GObject (HandlerID)
import Prim.Row as R

data Service

class BindServiceProp ∷ Service → Symbol → Row Type → Type → Constraint
class
  BindServiceProp service prop props ty
  | service → props
  , service prop → ty
  , props prop → ty
  where
  bindServiceProp ∷ ∀ rt. R.Cons prop ty rt props ⇒ Effect (Binding ty)

-- This class mimics `GObjectSignal` but allows the instances
-- to not expose the service object and wrap the callbacks so
-- that the object doesn't get passed to them. The former is simply
-- redundant because the object is known statically, the latter
-- is usually highly unsafe due to services representing mutable objects.
class ServiceConnect ∷ Service → Symbol → Row Type → Type → Constraint
class
  ServiceConnect service prop props callback
  | service → props
  , props prop → callback
  where
  connectService
    ∷ ∀ rt
    . R.Cons prop callback rt props
    ⇒ callback
    → Effect (HandlerID service)


module AGS.Service where

import AGS.Binding (Binding)
import Effect (Effect)
import GObject (HandlerID)

data Service

class BindServiceProp ∷ ∀ k. Service → k → Type → Constraint
class BindServiceProp s p a | s p → a where
  bindServiceProp ∷ Effect (Binding a)

class ConnectService ∷ Service → Type → Constraint
class ConnectService service signal where
  connectService ∷ signal → Effect HandlerID


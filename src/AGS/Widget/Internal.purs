module AGS.Widget.Internal
  ( AGSWidgetProps
  , AnyF
  , Any
  , mkAny
  , grabFocus
  , withInterval
  , unsafeWidgetUpdate
  ) where

import Prelude

import AGS.Binding (SelfOrBinding)
import Data.Exists (Exists, mkExists)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Gtk.Widget (GtkWidgetProps, Widget)
import Record.Studio.Keys (class Keys, keys)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

type AGSWidgetProps r =
  GtkWidgetProps
    +
      ( setup ∷ EffectFn1 Widget Unit
      , className ∷ SelfOrBinding String
      , classNames ∷ Array String
      , css ∷ String
      , hpack ∷ String {- TODO make it a proper type -}
      , vpack ∷ String {- TODO make it a proper type -}
      , cursor ∷ String {- TODO make it a proper type -}
      , attribute ∷ Any
      | r
      )

newtype AnyF a = AnyF a

type Any = Exists AnyF

-- TODO move out of the internal module
mkAny ∷ ∀ a. a → Any
mkAny = mkExists <<< AnyF

-- * Methods

-- TODO move out of the internal module
foreign import grabFocus ∷ Widget → Effect Unit
foreign import withInterval ∷ Int → Effect Unit → Widget → Effect Unit

-- * Utils for widgets updates

unsafeWidgetUpdate
  ∷ ∀ @r
  . Keys r
  ⇒ Widget
  → ((Record r → Record r) → Effect Unit)
unsafeWidgetUpdate widget =
  let
    getProps = unsafeGetWidgetProps @r
    update f = unsafeUpdateWidgetProps (f (getProps widget)) widget
  in
    update

unsafeGetWidgetProps ∷ ∀ @r. Keys r ⇒ Widget → Record r
unsafeGetWidgetProps = unsafeGetwidgetPropsImpl (keys (Proxy @r))

foreign import unsafeGetwidgetPropsImpl ∷ ∀ r. Array String → Widget → Record r
foreign import unsafeUpdateWidgetProps ∷ ∀ r. Record r → Widget → Effect Unit


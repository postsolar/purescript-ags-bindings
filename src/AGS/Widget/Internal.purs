module AGS.Widget.Internal
  ( AGSWidgetProps
  , AnyF
  , Any
  , mkAny
  , unsafeWidgetUpdate
  , propsToValueOrBindings
  , ToValueOrBinding
  , class ToValueOrBindingC
  , toValueOrBinding
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  ) where

import Prelude

import AGS.Binding (Binding, ValueOrBinding)
import Data.Exists (Exists, mkExists)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Gtk.Widget (GtkWidgetProps, Widget)
import Heterogeneous.Mapping (class HMap, class Mapping, hmap)
import Prim.Row (class Union)
import Record.Studio.Keys (class Keys, keys)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))
import Untagged.Union (asOneOf)

type AGSWidgetProps r =
  GtkWidgetProps
    +
      ( setup ∷ EffectFn1 Widget Unit
      , className ∷ ValueOrBinding String
      , classNames ∷ Array String
      , css ∷ ValueOrBinding String
      , hpack ∷ ValueOrBinding String {- TODO make it a proper type -}
      , vpack ∷ ValueOrBinding String {- TODO make it a proper type -}
      , cursor ∷ ValueOrBinding String {- TODO make it a proper type -}
      , attribute ∷ ValueOrBinding Any
      | r
      )

newtype AnyF a = AnyF a

type Any = Exists AnyF

mkAny ∷ ∀ a. a → Any
mkAny = mkExists <<< AnyF

-- * Utils for widget construction

class ToValueOrBindingC a b | a → b where
  toValueOrBinding ∷ a → ValueOrBinding b

instance ToValueOrBindingC (Binding a) a where
  toValueOrBinding = asOneOf

else instance ToValueOrBindingC a a where
  toValueOrBinding = asOneOf

instance
  ToValueOrBindingC a b ⇒
  Mapping ToValueOrBinding a (ValueOrBinding b) where
  mapping _ = toValueOrBinding

-- Helper datatype for HMap
data ToValueOrBinding = ToValueOrBinding

-- Map any record with `toValueOrBinding` as long as the resultant row type `rout` is in union with `@props`.
-- Every field of `@props` needs to be of type `ValueOrBinding _`.
propsToValueOrBindings
  ∷ ∀ _rt rin rout @props
  . HMap ToValueOrBinding (Record rin) (Record rout)
  ⇒ Union rout _rt props
  ⇒ Record rin
  → Record rout
propsToValueOrBindings = hmap ToValueOrBinding

-- | Alias for a function creating a widget out of a record with any number of this widget's props.
-- | Types of the record's fields have to align with the `props` row such that for every `ValueOrBinding a`
-- | in the `props` row, every input record's field has to be either `a` or `Binding a`.
type MkWidget props =
  ( ∀ _rt _rin _rout
    . HMap ToValueOrBinding (Record _rin) (Record _rout)
    ⇒ Union _rout _rt props
    ⇒ Record _rin
    → Widget
  )

-- | Same as `MkWidget`, but with an update function, which accepts a function `{ | props } → { | props }`
-- | and returns `Effect Unit`.
type MkWidgetWithUpdates props =
  ( ∀ _rt _rin _rout
    . HMap ToValueOrBinding (Record _rin) (Record _rout)
    ⇒ Union _rout _rt props
    ⇒ Record _rin
    → Widget /\ ((Record props → Record props) → Effect Unit)
  )

mkWidgetWithUpdates
  ∷ ∀ props. Keys props ⇒ MkWidget props → MkWidgetWithUpdates props
mkWidgetWithUpdates ctor props = widget /\ update
  where
  widget = ctor props
  update = unsafeWidgetUpdate @props widget

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


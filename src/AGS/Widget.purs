module AGS.Widget
  ( AGSWidgetProps
  , AnyF
  , Any
  , mkAny
  , unsafeSetProperty
  , grabFocus
  , withInterval
  , module AGS.Binding
  , module Gtk.Widget
  ) where

import Prelude

import AGS.Binding (SelfOrBinding)
import Data.Exists (Exists, mkExists)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Gtk.Widget (GtkWidgetProps, Widget)
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

mkAny ∷ ∀ a. a → Any
mkAny = mkExists <<< AnyF

-- * Methods

foreign import unsafeSetProperty ∷ ∀ a. String → a → Widget → Effect Unit

foreign import grabFocus ∷ Widget → Effect Unit

foreign import withInterval ∷ Int → Effect Unit → Widget → Effect Unit


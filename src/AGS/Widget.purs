module AGS.Widget
  ( grabFocus
  , withInterval
  , destroy
  , module Exports
  ) where

import AGS.Binding
  ( class BindProp
  , Binding
  , ValueOrBinding
  , bindProp
  , overBinding
  , overBoth
  , overValue
  ) as Exports
import AGS.Widget.Internal
  ( class ToValueOrBindingC
  , AGSWidgetProps
  , Any
  , AnyF
  , BoxProps
  , ButtonProps
  , CenterBoxProps
  , CircularProgressProps
  , EntryProps
  , EventBoxProps
  , IconProps
  , LabelProps
  , Mark
  , MarkPosition
  , MenuItemProps
  , MenuProps
  , MkWidget
  , MkWidgetWithUpdates
  , OverlayProps
  , ProgressBarProps
  , RevealerProps
  , ScrollableProps
  , SliderProps
  , StackProps
  , ToValueOrBinding
  , box
  , box'
  , button
  , button'
  , centerBox
  , centerBox'
  , circularProgress
  , circularProgress'
  , entry
  , entry'
  , eventBox
  , eventBox'
  , icon
  , icon'
  , label
  , label'
  , markPositionBottom
  , markPositionLeft
  , markPositionRight
  , markPositionTop
  , menu
  , menu'
  , menuItem
  , menuItem'
  , mkAny
  , overlay
  , overlay'
  , progressBar
  , progressBar'
  , propsToValueOrBindings
  , revealer
  , revealer'
  , scrollable
  , scrollable'
  , slider
  , slider'
  , stack
  , stack'
  , toValueOrBinding
  , withUpdates
  ) as Exports
import AGS.Widget.Window (Window, WindowProps, window) as Exports
import Effect (Effect)
import Effect.Uncurried
  ( EffectFn1
  , EffectFn2
  , EffectFn3
  , EffectFn4
  , mkEffectFn1
  , mkEffectFn2
  , mkEffectFn3
  , mkEffectFn4
  ) as Exports
import Gtk.Widget (Widget)
import Gtk.Widget (Widget) as Exports
import Prelude (Unit)
import Untagged.Union (asOneOf) as Exports

-- * Methods

foreign import grabFocus ∷ Widget → Effect Unit
foreign import withInterval ∷ Int → Effect Unit → Widget → Effect Unit
foreign import destroy ∷ Widget → Effect Unit


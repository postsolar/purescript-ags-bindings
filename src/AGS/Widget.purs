module AGS.Widget
  ( grabFocus
  , withInterval
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
import AGS.Widget.Box (BoxProps, box, box') as Exports
import AGS.Widget.Button (ButtonProps, button, button') as Exports
import AGS.Widget.CenterBox (CenterBoxProps, centerBox, centerBox') as Exports
import AGS.Widget.CircularProgress
  ( CircularProgressProps
  , circularProgress
  , circularProgress'
  ) as Exports
import AGS.Widget.Entry (EntryProps, entry, entry') as Exports
import AGS.Widget.EventBox (EventBoxProps, eventBox, eventBox') as Exports
import AGS.Widget.Icon (IconProps, icon, icon') as Exports
import AGS.Widget.Internal (AGSWidgetProps, Any, AnyF, mkAny) as Exports
import AGS.Widget.Label (LabelProps, label, label') as Exports
import AGS.Widget.Menu (MenuProps, menu, menu') as Exports
import AGS.Widget.Menu.Item (MenuItemProps, menuItem) as Exports
import AGS.Widget.Overlay (OverlayProps, overlay, overlay') as Exports
import AGS.Widget.ProgressBar (ProgressBarProps, progressBar, progressBar') as Exports
import AGS.Widget.Revealer
  ( GtkRevealerTransitionType
  , RevealerProps
  , revealer
  , revealer'
  , transitions
  ) as Exports
import AGS.Widget.Scrollable (ScrollableProps, scrollable, scrollable') as Exports
import AGS.Widget.Slider
  ( Mark
  , MarkPosition
  , SliderProps
  , markPositionBottom
  , markPositionLeft
  , markPositionRight
  , markPositionTop
  , slider
  , slider'
  ) as Exports
import AGS.Widget.Stack (StackProps, stack, stack') as Exports
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


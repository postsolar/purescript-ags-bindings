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
import AGS.Widget.Box (BoxProps, UpdateBoxProps, box, box') as Exports
import AGS.Widget.Button (ButtonProps, UpdateButtonProps, button, button') as Exports
import AGS.Widget.CenterBox
  ( CenterBoxProps
  , UpdateCenterBoxProps
  , centerBox
  , centerBox'
  ) as Exports
import AGS.Widget.CircularProgress
  ( CircularProgressProps
  , UpdateCircularProgressProps
  , circularProgress
  , circularProgress'
  ) as Exports
import AGS.Widget.Entry (EntryProps, UpdateEntryProps, entry, entry') as Exports
import AGS.Widget.EventBox
  ( EventBoxProps
  , UpdateEventBoxProps
  , eventBox
  , eventBox'
  ) as Exports
import AGS.Widget.Icon (IconProps, UpdateIconProps, icon, icon') as Exports
import AGS.Widget.Internal
  ( AGSWidgetProps
  , Any
  , AnyF
  , mkAny
  , unsafeWidgetUpdate
  ) as Exports
import AGS.Widget.Label (LabelProps, label, label') as Exports
import AGS.Widget.Menu (MenuProps, UpdateMenuProps, menu, menu') as Exports
import AGS.Widget.Menu.Item (MenuItem, MenuItemProps, menuItem, menuItemImpl) as Exports
import AGS.Widget.Overlay (OverlayProps, UpdateOverlayProps, overlay, overlay') as Exports
import AGS.Widget.ProgressBar
  ( ProgressBarProps
  , UpdateProgressBarProps
  , progressBar
  , progressBar'
  ) as Exports
import AGS.Widget.Revealer
  ( GtkRevealerTransitionType
  , RevealerProps
  , UpdateRevealerProps
  , revealer
  , revealer'
  , transitions
  ) as Exports
import AGS.Widget.Scrollable
  ( ScrollableProps
  , UpdateScrollableProps
  , scrollable
  , scrollable'
  ) as Exports
import AGS.Widget.Slider
  ( Mark
  , MarkPosition
  , SliderProps
  , UpdateSliderProps
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


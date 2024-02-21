module AGS.Widget.Internal
  ( -- Widget utils
    AGSWidgetProps
  , AnyF
  , Any
  , mkAny
  , propsToValueOrBindings
  , ToValueOrBinding
  , class ToValueOrBindingC
  , toValueOrBinding
  , MkWidget
  , MkWidgetWithUpdates
  , withUpdates

  -- Widgets
  , box
  , box'
  , BoxProps
  , button
  , button'
  , ButtonProps
  , centerBox
  , centerBox'
  , CenterBoxProps
  , circularProgress
  , circularProgress'
  , CircularProgressProps
  , entry
  , entry'
  , EntryProps
  , eventBox
  , eventBox'
  , EventBoxProps
  , icon
  , icon'
  , IconProps
  , label
  , label'
  , LabelProps
  , menu
  , menu'
  , MenuProps
  , menuItem
  , menuItem'
  , MenuItemProps
  , overlay
  , overlay'
  , OverlayProps
  , progressBar
  , progressBar'
  , ProgressBarProps
  , revealer
  , revealer'
  , RevealerProps
  , scrollable
  , scrollable'
  , ScrollableProps
  , slider
  , slider'
  , SliderProps
  , Mark
  , MarkPosition
  , markPositionTop
  , markPositionLeft
  , markPositionRight
  , markPositionBottom
  , stack
  , stack'
  , StackProps
  ) where

import Prelude

import AGS.Binding (Binding, ValueOrBinding)
import Data.Exists (Exists, mkExists)
import Data.Maybe (Maybe, maybe)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Foreign.Object (Object)
import Gtk.Actionable (GtkActionableProps)
import Gtk.Activatable (GtkActivatableProps)
import Gtk.Box (GtkBoxProps)
import Gtk.Button (GtkButtonProps)
import Gtk.Container (GtkContainerProps)
import Gtk.Entry (GtkEntryProps)
import Gtk.Image (GtkImageProps)
import Gtk.Label (GtkLabelProps)
import Gtk.Menu (GtkMenuProps)
import Gtk.MenuItem (GtkMenuItemProps)
import Gtk.MenuShell (GtkMenuShellProps)
import Gtk.Misc (GtkMiscProps)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.ProgressBar (GtkProgressBarProps)
import Gtk.Range (GtkRangeProps)
import Gtk.Revealer (GtkRevealerProps)
import Gtk.Scale (GtkScaleProps)
import Gtk.ScrollType (GtkScrollType)
import Gtk.ScrolledWindow (GtkScrolledWindowProps)
import Gtk.Stack (GtkStackProps)
import Gtk.Widget (GtkWidgetProps, Widget)
import Heterogeneous.Mapping (class HMap, class Mapping, hmap)
import Prim.Row (class Union)
import Record.Studio.Keys (class Keys, keys)
import Record.Unsafe as RU
import Type.Proxy (Proxy(..))
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)
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

-- *** Utils for widget construction

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

-- | Construct a widget with a function which, when applied to a function
-- | from widget properties to widget properties, would update that widget.
-- |
-- | ```purescript
-- | do
-- |   let box /\ updateBox = Widget.withUpdates Widget.box {}
-- |   updateBox (\w -> w { css = w.css <> " color: red;" })
-- |   pure box
-- | ```
-- |
-- | Note: type inference may be weak here, use visible type application to aid the compiler.
-- | For example `withUpdates @(LabelProps ()) label { label: "my label" }`
withUpdates ∷ ∀ @props. Keys props ⇒ MkWidget props → MkWidgetWithUpdates props
withUpdates ctor props = widget /\ update

  where
  widget = ctor props
  update = unsafeWidgetUpdate @props widget

foreign import isBinding ∷ ∀ a. a → Boolean

-- *** Utils for widgets updates

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

-- *** Widgets

foreign import boxImpl ∷ Record (BoxProps ()) → Widget
foreign import buttonImpl ∷ Record (ButtonProps ()) → Widget
foreign import centerBoxImpl ∷ Record (CenterBoxProps ()) → Widget
foreign import circularProgressImpl ∷ Record (CircularProgressProps ()) → Widget
foreign import entryImpl ∷ Record (EntryProps ()) → Widget
foreign import eventBoxImpl ∷ Record (EventBoxProps ()) → Widget
foreign import iconImpl ∷ Record (IconProps ()) → Widget
foreign import labelImpl ∷ Record (LabelProps ()) → Widget
foreign import menuImpl ∷ Record (MenuProps ()) → Widget
foreign import menuItemImpl ∷ Record (MenuItemProps ()) → Widget
foreign import overlayImpl ∷ Record (OverlayProps ()) → Widget
foreign import progressBarImpl ∷ Record (ProgressBarProps ()) → Widget
foreign import revealerImpl ∷ Record (RevealerProps ()) → Widget
foreign import scrollableImpl ∷ Record (ScrollableProps ()) → Widget
foreign import sliderImpl ∷ Record (SliderProps ()) → Widget
foreign import stackImpl ∷ Record (StackProps ()) → Widget

-- * Box

type BoxProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkOrientableProps
    + GtkBoxProps
    +
      ( vertical ∷ ValueOrBinding Boolean
      , children ∷ ValueOrBinding (Array Widget)
      | r
      )

box ∷ MkWidget (BoxProps ())
box = boxImpl <<< unsafeCoerce <<< propsToValueOrBindings @(BoxProps ())

box' ∷ MkWidgetWithUpdates (BoxProps ())
box' = withUpdates box

-- * Button

type ButtonProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkButtonProps
    +
      ( child ∷ ValueOrBinding Widget
      , onClicked ∷ ValueOrBinding (Effect Unit)
      , onPrimaryClick ∷ ValueOrBinding (Effect Unit)
      , onSecondaryClick ∷ ValueOrBinding (Effect Unit)
      , onMiddleClick ∷ ValueOrBinding (Effect Unit)
      , onPrimaryClickRelease ∷ ValueOrBinding (Effect Unit)
      , onSecondaryClickRelease ∷ ValueOrBinding (Effect Unit)
      , onMiddleClickRelease ∷ ValueOrBinding (Effect Unit)
      , onHover ∷ ValueOrBinding (Effect Unit)
      , onHoverLost ∷ ValueOrBinding (Effect Unit)
      , onScrollUp ∷ ValueOrBinding (Effect Unit)
      , onScrollDown ∷ ValueOrBinding (Effect Unit)
      | r
      )

button ∷ MkWidget (ButtonProps ())
button = buttonImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(ButtonProps ())

button' ∷ MkWidgetWithUpdates (ButtonProps ())
button' = withUpdates button

-- * CenterBox

type CenterBoxProps r =
  BoxProps
    ( startWidget ∷ ValueOrBinding Widget
    , centerWidget ∷ ValueOrBinding Widget
    , endWidget ∷ ValueOrBinding Widget
    | r
    )

centerBox ∷ MkWidget (CenterBoxProps ())
centerBox = centerBoxImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(CenterBoxProps ())

centerBox' ∷ MkWidgetWithUpdates (CenterBoxProps ())
centerBox' = withUpdates centerBox

-- * CircularProgress

type CircularProgressProps r =
  AGSWidgetProps
    + GtkContainerProps
    +
      ( startAt ∷ ValueOrBinding Number
      , endAt ∷ ValueOrBinding Number
      , inverted ∷ ValueOrBinding Boolean
      , rounded ∷ ValueOrBinding Boolean
      , value ∷ ValueOrBinding Number
      | r
      )

circularProgress ∷ MkWidget (CircularProgressProps ())
circularProgress = circularProgressImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(CircularProgressProps ())

circularProgress' ∷ MkWidgetWithUpdates (CircularProgressProps ())
circularProgress' = withUpdates circularProgress

-- * Entry

type EntryProps r =
  AGSWidgetProps
    + GtkEntryProps
    +
      ( onChange ∷ ValueOrBinding (EffectFn1 Widget Unit)
      , onAccept ∷ ValueOrBinding (EffectFn1 Widget Unit)
      | r
      )

entry ∷ MkWidget (EntryProps ())
entry = entryImpl <<< unsafeCoerce <<< propsToValueOrBindings @(EntryProps ())

entry' ∷ MkWidgetWithUpdates (EntryProps ())
entry' = withUpdates entry

-- * EventBox

type EventBoxProps r =
  AGSWidgetProps
    + GtkContainerProps
    +
      ( onPrimaryClick ∷ ValueOrBinding (Effect Unit)
      , onSecondaryClick ∷ ValueOrBinding (Effect Unit)
      , onMiddleClick ∷ ValueOrBinding (Effect Unit)
      , onPrimaryClickRelease ∷ ValueOrBinding (Effect Unit)
      , onSecondaryClickRelease ∷ ValueOrBinding (Effect Unit)
      , onMiddleClickRelease ∷ ValueOrBinding (Effect Unit)
      , onHover ∷ ValueOrBinding (Effect Unit)
      , onHoverLost ∷ ValueOrBinding (Effect Unit)
      , onScrollUp ∷ ValueOrBinding (Effect Unit)
      , onScrollDown ∷ ValueOrBinding (Effect Unit)
      | r
      )

eventBox ∷ MkWidget (EventBoxProps ())
eventBox = eventBoxImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(EventBoxProps ())

eventBox' ∷ MkWidgetWithUpdates (EventBoxProps ())
eventBox' = withUpdates eventBox

-- * Icon

type IconProps r =
  AGSWidgetProps
    + GtkMiscProps
    + GtkImageProps
    +
      ( icon ∷ ValueOrBinding String
      , size ∷ ValueOrBinding Number
      | r
      )

icon ∷ MkWidget (IconProps ())
icon = iconImpl <<< unsafeCoerce <<< propsToValueOrBindings @(IconProps ())

icon' ∷ MkWidgetWithUpdates (IconProps ())
icon' = withUpdates icon

-- * Label

type LabelProps r =
  AGSWidgetProps
    + GtkLabelProps
    +
      ( justification ∷ ValueOrBinding String {- TODO make it a proper type -}
      , truncate ∷ ValueOrBinding String {- TODO make it a proper type -}
      | r
      )

label ∷ MkWidget (LabelProps ())
label = labelImpl <<< unsafeCoerce <<< propsToValueOrBindings @(LabelProps ())

label' ∷ MkWidgetWithUpdates (LabelProps ())
label' = withUpdates label

-- * Menu

type MenuProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkMenuProps Widget
    + GtkMenuShellProps
    +
      ( children ∷ ValueOrBinding (Array Widget)
      , onPopup ∷ ValueOrBinding (Effect Unit)
      , onMoveScroll ∷ ValueOrBinding (EffectFn1 GtkScrollType Unit)
      | r
      )

menu ∷ MkWidget (MenuProps ())
menu = menuImpl <<< unsafeCoerce <<< propsToValueOrBindings @(MenuProps ())

menu' ∷ MkWidgetWithUpdates (MenuProps ())
menu' = withUpdates menu

-- * MenuItem

type MenuItemProps r =
  AGSWidgetProps
    + GtkActionableProps
    + GtkActivatableProps
    + GtkContainerProps
    -- should be somehow constrained to `Menu` rather than all widgets
    + GtkMenuItemProps Widget
    +
      ( child ∷ ValueOrBinding Widget
      , onActivate ∷ ValueOrBinding (Effect Boolean)
      , onSelect ∷ ValueOrBinding (Effect Boolean)
      , onDeselect ∷ ValueOrBinding (Effect Boolean)
      | r
      )

menuItem ∷ MkWidget (MenuItemProps ())
menuItem = menuItemImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(MenuItemProps ())

menuItem' ∷ MkWidgetWithUpdates (MenuItemProps ())
menuItem' = withUpdates menuItem

-- * Overlay

type OverlayProps r =
  AGSWidgetProps
    +
      ( child ∷ ValueOrBinding Widget
      , overlays ∷ ValueOrBinding (Array Widget)
      , passThrough ∷ ValueOrBinding Boolean
      | r
      )

overlay ∷ MkWidget (OverlayProps ())
overlay = overlayImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(OverlayProps ())

overlay' ∷ MkWidgetWithUpdates (OverlayProps ())
overlay' = withUpdates overlay

-- * ProgressBar

type ProgressBarProps r =
  AGSWidgetProps
    + GtkOrientableProps
    + GtkProgressBarProps
    +
      ( vertical ∷ ValueOrBinding Boolean
      , value ∷ ValueOrBinding Number
      | r
      )

progressBar ∷ MkWidget (ProgressBarProps ())
progressBar = progressBarImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(ProgressBarProps ())

progressBar' ∷ MkWidgetWithUpdates (ProgressBarProps ())
progressBar' = withUpdates progressBar

-- * Revealer

type RevealerProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkRevealerProps
    + r

revealer ∷ MkWidget (RevealerProps ())
revealer = revealerImpl <<< unsafeCoerce

revealer' ∷ MkWidgetWithUpdates (RevealerProps ())
revealer' = withUpdates revealer

-- * Scrollable

type ScrollableProps r =
  AGSWidgetProps
    + GtkScrolledWindowProps
    + GtkContainerProps
    +
      ( hscroll ∷ ValueOrBinding String {- TODO make it a proper type -}
      , vscroll ∷ ValueOrBinding String {- TODO make it a proper type -}
      | r
      )

scrollable ∷ MkWidget (ScrollableProps ())
scrollable = scrollableImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(ScrollableProps ())

scrollable' ∷ MkWidgetWithUpdates (ScrollableProps ())
scrollable' = withUpdates scrollable

-- * Slider

foreign import data MarkPosition ∷ Type

markPositionTop = unsafeCoerce "top" ∷ MarkPosition
markPositionLeft = unsafeCoerce "left" ∷ MarkPosition
markPositionRight = unsafeCoerce "right" ∷ MarkPosition
markPositionBottom = unsafeCoerce "bottom" ∷ MarkPosition

type Mark =
  { at ∷ Number
  , label ∷ Maybe String
  , position ∷ Maybe MarkPosition
  }

type SliderProps r =
  AGSWidgetProps
    + GtkOrientableProps
    + GtkScaleProps
    + GtkRangeProps
    +
      ( vertical ∷ ValueOrBinding Boolean
      , value ∷ ValueOrBinding Number
      , min ∷ ValueOrBinding Number
      , max ∷ ValueOrBinding Number
      , marks ∷ ValueOrBinding (Array Mark)
      , onChange ∷ ValueOrBinding (Number → Effect Unit)
      | r
      )

slider ∷ MkWidget (SliderProps ())
slider = sliderImpl
  <<< unsafeCoerce
  <<< propsToValueOrBindings @(SliderProps ())
  <<< prepare

  where
  prepare r =
    r
      #
        ( if RU.unsafeHas "marks" r then
            RU.unsafeSet "marks"
              (prepareMarks $ RU.unsafeGet "marks" r)
          else
            identity
        )
      #
        ( if RU.unsafeHas "onChange" r then
            RU.unsafeSet "onChange"
              (prepareOnChangeCb $ RU.unsafeGet "onChange" r)
          else
            identity
        )

  prepareOnChangeCb
    ∷ (Number → Effect Unit) {- or Binding -}
    → EffectFn1 { value ∷ Number } Unit {- or Binding -}
  prepareOnChangeCb fn =
    if isBinding fn then
      unsafeCoerce $ map (\f → mkEffectFn1 \{ value } → f value)
        (unsafeCoerce fn ∷ Binding (Number → Effect Unit))
    else
      mkEffectFn1 \{ value } → fn value

  prepareMarks
    ∷ Array Mark {- or Binding (Array Mark) -}
    → Array (Array Number) {- or Binding (Array (Array Number)) -}
  prepareMarks ms =
    if isBinding ms then
      unsafeCoerce $ map (map prepareMark)
        (unsafeCoerce ms ∷ Binding (Array Mark))
    else
      map prepareMark ms

  prepareMark ∷ Mark → Array (Number {- or String -} )
  prepareMark { at, label: markLabel, position } =
    [ at ] <> maybe [] unsafeCoerce markLabel <> maybe [] unsafeCoerce position

slider' ∷ MkWidgetWithUpdates (SliderProps ())
slider' = withUpdates slider

-- * Stack

type StackProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkStackProps Widget
    +
      ( children ∷ ValueOrBinding (Object Widget)
      , shown ∷ ValueOrBinding String
      | r
      )

stack ∷ MkWidget (StackProps ())
stack = stackImpl <<< unsafeCoerce <<< propsToValueOrBindings @(StackProps ())

stack' ∷ MkWidgetWithUpdates (StackProps ())
stack' = withUpdates stack


module AGS.Widget.Slider
  ( SliderProps
  , Mark
  , MarkPosition
  , slider
  , slider'
  , markPositionTop
  , markPositionLeft
  , markPositionRight
  , markPositionBottom
  ) where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.Range (GtkRangeProps)
import Gtk.Scale (GtkScaleProps)
import Gtk.Widget (Widget)
import Record.Unsafe as RU
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

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
slider = sliderImpl <<< prepare <<< propsToValueOrBindings @(SliderProps ())
  where
  prepare r =
    r
      #
        ( if RU.unsafeHas "marks" r then
            RU.unsafeSet "marks"
              (prepareMark `map @Array` RU.unsafeGet "marks" r)
          else
            identity
        )
      #
        ( if RU.unsafeHas "onChange" r then
            RU.unsafeSet "onChange"
              (mkEffectFn1 \{ value } → RU.unsafeGet "onChange" r value)
          else
            identity
        )

  prepareMark { at, label, position } =
    [ at ] <> maybe [] unsafeCoerce label <> maybe [] unsafeCoerce position

slider' ∷ MkWidgetWithUpdates (SliderProps ())
slider' = mkWidgetWithUpdates slider

foreign import sliderImpl ∷ ∀ r. Record r → Widget


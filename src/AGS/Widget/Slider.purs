module AGS.Widget.Slider
  ( SliderProps
  , Mark
  , MarkPosition
  , slider
  , markPositionTop
  , markPositionLeft
  , markPositionRight
  , markPositionBottom
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps)
import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.Range (GtkRangeProps)
import Gtk.Scale (GtkScaleProps)
import Gtk.Widget (Widget)
import Prim.Row (class Union)
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
      ( vertical ∷ Boolean
      , value ∷ Number
      , min ∷ Number
      , max ∷ Number
      , marks ∷ Array Mark
      , onChange ∷ Number → Effect Unit
      | r
      )

slider ∷ ∀ r r'. Union r r' (SliderProps ()) ⇒ Record r → Widget
slider = sliderImpl <<< prepare
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

foreign import sliderImpl ∷ ∀ r. Record r → Widget


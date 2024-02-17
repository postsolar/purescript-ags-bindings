module AGS.Widget.CenterBox
  ( CenterBoxProps
  , UpdateCenterBoxProps
  , centerBox
  , centerBox'
  ) where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Box (BoxProps)
import AGS.Widget.Internal (unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Widget (Widget)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

type CenterBoxProps r =
  BoxProps
    ( startWidget ∷ ValueOrBinding Widget
    , centerWidget ∷ ValueOrBinding Widget
    , endWidget ∷ ValueOrBinding Widget
    | r
    )

centerBox
  ∷ ∀ r r'
  . Union r r' (CenterBoxProps ())
  ⇒ Record r
  → Widget
centerBox = centerBoxImpl <<< unsafeCoerce

foreign import centerBoxImpl ∷ Record (CenterBoxProps ()) → Widget

type UpdateCenterBoxProps =
  Record (CenterBoxProps ()) → Record (CenterBoxProps ())

centerBox'
  ∷ ∀ r r'
  . Union r r' (CenterBoxProps ())
  ⇒ Record r
  → Widget /\ (UpdateCenterBoxProps → Effect Unit)
centerBox' props =
  let
    widget = centerBox props
    update = unsafeWidgetUpdate @(CenterBoxProps ()) widget
  in
    widget /\ update


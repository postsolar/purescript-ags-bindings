module AGS.Widget.Label
  ( LabelProps
  , label
  , label'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Label (GtkLabelProps)
import Gtk.Widget (Widget)
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type LabelProps r =
  AGSWidgetProps
    + GtkLabelProps
    +
      ( justification ∷ String {- TODO make it a proper type -}
      , truncate ∷ String {- TODO make it a proper type -}
      | r
      )

label ∷ ∀ r r'. Union r r' (LabelProps ()) ⇒ Record r → Widget
label = labelImpl <<< unsafeCoerce

foreign import labelImpl
  ∷ ∀ (r ∷ Row Type)
  . Record r
  → Widget

type UpdateLabelProps = Record (LabelProps ()) → Record (LabelProps ())

label'
  ∷ ∀ r r'
  . Union r r' (LabelProps ())
  ⇒ Record r
  → Widget /\ (UpdateLabelProps → Effect Unit)
label' props =
  let
    widget = label props
    update = unsafeWidgetUpdate @(LabelProps ()) widget
  in
    widget /\ update


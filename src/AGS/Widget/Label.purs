module AGS.Widget.Label
  ( LabelProps
  , label
  ) where

import Gtk.Widget (Widget)
import AGS.Widget.Internal (AGSWidgetProps)
import Gtk.Label (GtkLabelProps)
import Prelude ((<<<))
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


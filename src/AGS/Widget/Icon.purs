module AGS.Widget.Icon
  ( IconProps
  , icon
  ) where

import AGS.Widget.Internal (AGSWidgetProps)
import Gtk.Image (GtkImageProps)
import Gtk.Misc (GtkMiscProps)
import Gtk.Widget (Widget)
import Prelude ((<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type IconProps r =
  AGSWidgetProps
    + GtkMiscProps
    + GtkImageProps
    +
      ( icon ∷ String
      , size ∷ Number
      | r
      )

icon ∷ ∀ r r'. Union r r' (IconProps ()) ⇒ Record r → Widget
icon = iconImpl <<< unsafeCoerce

foreign import iconImpl ∷ Record (IconProps ()) → Widget


module AGS.Widget.Icon
  ( IconProps
  , UpdateIconProps
  , icon
  , icon'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Image (GtkImageProps)
import Gtk.Misc (GtkMiscProps)
import Gtk.Widget (Widget)
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

type UpdateIconProps = Record (IconProps ()) → Record (IconProps ())

icon'
  ∷ ∀ r r'
  . Union r r' (IconProps ())
  ⇒ Record r
  → Widget /\ (UpdateIconProps → Effect Unit)
icon' props =
  let
    widget = icon props
    update = unsafeWidgetUpdate @(IconProps ()) widget
  in
    widget /\ update


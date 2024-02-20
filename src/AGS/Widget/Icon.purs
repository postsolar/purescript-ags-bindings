module AGS.Widget.Icon (IconProps, icon, icon') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Image (GtkImageProps)
import Gtk.Misc (GtkMiscProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

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

foreign import iconImpl ∷ Record (IconProps ()) → Widget

icon' ∷ MkWidgetWithUpdates (IconProps ())
icon' = mkWidgetWithUpdates icon


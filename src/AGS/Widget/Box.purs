module AGS.Widget.Box (BoxProps, box, box') where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Gtk.Box (GtkBoxProps)
import Gtk.Container (GtkContainerProps)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

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
box' = mkWidgetWithUpdates box

foreign import boxImpl ∷ Record (BoxProps ()) → Widget


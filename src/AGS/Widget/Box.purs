module AGS.Widget.Box
  ( BoxProps
  , box
  ) where

import Gtk.Widget (Widget)
import AGS.Widget.Internal (AGSWidgetProps)
import AGS.Binding (SelfOrBinding)
import Gtk.Box (GtkBoxProps)
import Gtk.Container (GtkContainerProps)
import Gtk.Orientable (GtkOrientableProps)
import Prelude ((<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type BoxProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkOrientableProps
    + GtkBoxProps
    +
      ( vertical ∷ Boolean
      , children ∷ SelfOrBinding (Array Widget)
      | r
      )

box ∷ ∀ r r'. Union r r' (BoxProps ()) ⇒ Record r → Widget
box = boxImpl <<< unsafeCoerce

foreign import boxImpl ∷ Record (BoxProps ()) → Widget


module AGS.Widget.Stack
  ( StackProps
  , stack
  ) where

import AGS.Widget (AGSWidgetProps, Widget)
import Foreign.Object (Object)
import Gtk.Container (GtkContainerProps)
import Gtk.Stack (GtkStackProps)
import Prelude ((<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type StackProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkStackProps Widget
    +
      ( children ∷ Object Widget
      , shown ∷ String
      | r
      )

stack ∷ ∀ r r'. Union r r' (StackProps ()) ⇒ Record r → Widget
stack = stackImpl <<< unsafeCoerce

foreign import stackImpl ∷ Record (StackProps ()) → Widget


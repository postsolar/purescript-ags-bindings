module AGS.Widget.Stack
  ( StackProps
  , stack
  , stack'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Foreign.Object (Object)
import Gtk.Container (GtkContainerProps)
import Gtk.Stack (GtkStackProps)
import Gtk.Widget (Widget)
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

type UpdateStackProps = Record (StackProps ()) → Record (StackProps ())

stack'
  ∷ ∀ r r'
  . Union r r' (StackProps ())
  ⇒ Record r
  → Widget /\ (UpdateStackProps → Effect Unit)
stack' props =
  let
    widget = stack props
    update = unsafeWidgetUpdate @(StackProps ()) widget
  in
    widget /\ update


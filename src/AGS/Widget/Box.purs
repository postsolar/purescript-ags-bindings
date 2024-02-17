module AGS.Widget.Box
  ( BoxProps
  , UpdateBoxProps
  , box
  , box'
  ) where

import Prelude

import AGS.Binding (ValueOrBinding)
import AGS.Widget.Internal
  ( AGSWidgetProps
  , unsafeWidgetUpdate
  )
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Box (GtkBoxProps)
import Gtk.Container (GtkContainerProps)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.Widget (Widget)
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
      , children ∷ ValueOrBinding (Array Widget)
      | r
      )

box ∷ ∀ r r'. Union r r' (BoxProps ()) ⇒ Record r → Widget
box = boxImpl <<< unsafeCoerce

foreign import boxImpl ∷ Record (BoxProps ()) → Widget

type UpdateBoxProps = Record (BoxProps ()) → Record (BoxProps ())

box'
  ∷ ∀ r r'
  . Union r r' (BoxProps ())
  ⇒ Record r
  → Widget /\ (UpdateBoxProps → Effect Unit)
box' props =
  let
    widget = box props
    update = unsafeWidgetUpdate @(BoxProps ()) widget
  in
    widget /\ update


module AGS.Widget.Revealer
  ( RevealerProps
  , UpdateRevealerProps
  , revealer
  , revealer'
  , module Gtk.RevealerTransition
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Container (GtkContainerProps)
import Gtk.Revealer (GtkRevealerProps)
import Gtk.RevealerTransition (GtkRevealerTransitionType, transitions)
import Gtk.Widget (Widget)
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type RevealerProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkRevealerProps
    + r

revealer ∷ ∀ r r'. Union r r' (RevealerProps ()) ⇒ Record r → Widget
revealer = revealerImpl <<< unsafeCoerce

foreign import revealerImpl ∷ ∀ r. Record r → Widget

type UpdateRevealerProps = Record (RevealerProps ()) → Record (RevealerProps ())

revealer'
  ∷ ∀ r r'
  . Union r r' (RevealerProps ())
  ⇒ Record r
  → Widget /\ (UpdateRevealerProps → Effect Unit)
revealer' props =
  let
    widget = revealer props
    update = unsafeWidgetUpdate @(RevealerProps ()) widget
  in
    widget /\ update


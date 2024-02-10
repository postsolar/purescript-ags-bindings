module AGS.Widget.Revealer
  ( RevealerProps
  , revealer
  , module Gtk.RevealerTransition
  ) where

import AGS.Widget (AGSWidgetProps, Widget)
import Control.Category ((<<<))
import Gtk.Container (GtkContainerProps)
import Gtk.Revealer (GtkRevealerProps)
import Gtk.RevealerTransition (GtkRevealerTransitionType, transitions)
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


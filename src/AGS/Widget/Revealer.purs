module AGS.Widget.Revealer
  ( RevealerProps
  , revealer
  , revealer'
  , module Gtk.RevealerTransition
  ) where

import Prelude

import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  )
import Gtk.Container (GtkContainerProps)
import Gtk.Revealer (GtkRevealerProps)
import Gtk.RevealerTransition (GtkRevealerTransitionType, transitions)
import Gtk.Widget (Widget)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type RevealerProps r =
  AGSWidgetProps
    + GtkContainerProps
    + GtkRevealerProps
    + r

revealer ∷ MkWidget (RevealerProps ())
revealer = revealerImpl <<< unsafeCoerce

revealer' ∷ MkWidgetWithUpdates (RevealerProps ())
revealer' = mkWidgetWithUpdates revealer

foreign import revealerImpl ∷ ∀ r. Record r → Widget


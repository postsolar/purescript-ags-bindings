module Gtk.Revealer
  ( GtkRevealerProps
  , module Gtk.RevealerTransition
  ) where

import AGS.Binding (ValueOrBinding)
import Gtk.RevealerTransition (GtkRevealerTransitionType, transitions)

type GtkRevealerProps r =
  ( childRevealed ∷ ValueOrBinding Boolean
  , revealChild ∷ ValueOrBinding Boolean
  , transitionDuration ∷ ValueOrBinding Number
  , transitionType ∷ ValueOrBinding GtkRevealerTransitionType
  | r
  )


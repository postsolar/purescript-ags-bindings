module Gtk.Revealer
  ( GtkRevealerProps
  , module Gtk.RevealerTransition
  ) where

import Gtk.RevealerTransition (GtkRevealerTransitionType, transitions)

type GtkRevealerProps r =
  ( childRevealed ∷ Boolean
  , revealChild ∷ Boolean
  , transitionDuration ∷ Number
  , transitionType ∷ GtkRevealerTransitionType
  | r
  )


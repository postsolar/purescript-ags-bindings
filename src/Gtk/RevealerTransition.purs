module Gtk.RevealerTransition where

transitions
  ∷ { crossfade ∷ GtkRevealerTransitionType
    , none ∷ GtkRevealerTransitionType
    , slideDown ∷ GtkRevealerTransitionType
    , slideLeft ∷ GtkRevealerTransitionType
    , slideRight ∷ GtkRevealerTransitionType
    , slideUp ∷ GtkRevealerTransitionType
    }
transitions =
  { none
  , crossfade
  , slideRight
  , slideLeft
  , slideUp
  , slideDown
  }

foreign import data GtkRevealerTransitionType ∷ Type
foreign import none ∷ GtkRevealerTransitionType
foreign import crossfade ∷ GtkRevealerTransitionType
foreign import slideRight ∷ GtkRevealerTransitionType
foreign import slideLeft ∷ GtkRevealerTransitionType
foreign import slideUp ∷ GtkRevealerTransitionType
foreign import slideDown ∷ GtkRevealerTransitionType


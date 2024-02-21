module Gtk.Stack where

import AGS.Binding (ValueOrBinding)

foreign import data GtkStackTransitionType ∷ Type

foreign import transitions
  ∷ { none ∷ GtkStackTransitionType
    , crossfade ∷ GtkStackTransitionType
    , slideRight ∷ GtkStackTransitionType
    , slideLeft ∷ GtkStackTransitionType
    , slideUp ∷ GtkStackTransitionType
    , slideDown ∷ GtkStackTransitionType
    , slideLeftRight ∷ GtkStackTransitionType
    , slideUpDown ∷ GtkStackTransitionType
    , overUp ∷ GtkStackTransitionType
    , overDown ∷ GtkStackTransitionType
    , overLeft ∷ GtkStackTransitionType
    , overRight ∷ GtkStackTransitionType
    , underUp ∷ GtkStackTransitionType
    , underDown ∷ GtkStackTransitionType
    , underLeft ∷ GtkStackTransitionType
    , underRight ∷ GtkStackTransitionType
    , overUpDown ∷ GtkStackTransitionType
    , overDownUp ∷ GtkStackTransitionType
    , overLeftRight ∷ GtkStackTransitionType
    , overRightLeft ∷ GtkStackTransitionType
    }

-- Type parameter `a` is implied to be `Gtk.Widget` or anything that extends it
type GtkStackProps a r =
  ( hhomogeneous ∷ ValueOrBinding Boolean
  , homogeneous ∷ ValueOrBinding Boolean
  , interpolateSize ∷ ValueOrBinding Boolean
  , transitionDuration ∷ ValueOrBinding Number
  , transitionRunning ∷ ValueOrBinding Boolean
  , transitionType ∷ ValueOrBinding GtkStackTransitionType
  , vhomogeneous ∷ ValueOrBinding Boolean
  , visibleChild ∷ ValueOrBinding a
  , visibleChildName ∷ ValueOrBinding String
  | r
  )

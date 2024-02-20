module Gtk.ProgressBar where

import AGS.Binding (ValueOrBinding)

type GtkProgressBarProps r =
  ( -- ellipsize ∷ Pango.EllipsizeMode
    fraction ∷ ValueOrBinding Number
  , inverted ∷ ValueOrBinding Boolean
  , pulseStep ∷ ValueOrBinding Number
  , showText ∷ ValueOrBinding Boolean
  , text ∷ ValueOrBinding String
  | r
  )


module Gtk.ProgressBar where

type GtkProgressBarProps r =
  ( -- ellipsize ∷ Pango.EllipsizeMode
    fraction ∷ Number
  , inverted ∷ Boolean
  , pulseStep ∷ Number
  , showText ∷ Boolean
  , text ∷ String
  | r
  )


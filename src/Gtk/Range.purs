module Gtk.Range where

type GtkRangeProps r =
  ( -- adjustment ∷ Gtk.Adjustment
    fillLevel ∷ Number
  , inverted ∷ Boolean
  -- , lowerStepperSensitivity ∷ Gtk.SensitivityType
  , restrictToFillLevel ∷ Boolean
  , roundDigits ∷ Number
  , showFillLevel ∷ Boolean
  -- , upperStepperSensitivity ∷ Gtk.SensitivityType
  | r
  )


module Gtk.Range where

import AGS.Binding (ValueOrBinding)

type GtkRangeProps r =
  ( -- adjustment ∷ ValueOrBinding Gtk.Adjustment
    fillLevel ∷ ValueOrBinding Number
  , inverted ∷ ValueOrBinding Boolean
  -- , lowerStepperSensitivity ∷ ValueOrBinding Gtk.SensitivityType
  , restrictToFillLevel ∷ ValueOrBinding Boolean
  , roundDigits ∷ ValueOrBinding Number
  , showFillLevel ∷ ValueOrBinding Boolean
  -- , upperStepperSensitivity ∷ ValueOrBinding Gtk.SensitivityType
  | r
  )


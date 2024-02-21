module Gtk.Scale where

import AGS.Binding (ValueOrBinding)

type GtkScaleProps r =
  ( digits ∷ ValueOrBinding Number
  , drawValue ∷ ValueOrBinding Boolean
  , hasOrigin ∷ ValueOrBinding Boolean
  -- , valuePos ∷ ValueOrBinding Gtk.PositionType
  | r
  )


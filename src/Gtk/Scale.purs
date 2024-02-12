module Gtk.Scale where

type GtkScaleProps r =
  ( digits ∷ Number
  , drawValue ∷ Boolean
  , hasOrigin ∷ Boolean
  -- , valuePos ∷ Gtk.PositionType
  | r
  )


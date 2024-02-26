module Gtk.Misc where

import AGS.Binding (ValueOrBinding)

type GtkMiscProps r =
  ( xalign ∷ ValueOrBinding Int
  , xpad ∷ ValueOrBinding Number
  , yalign ∷ ValueOrBinding Int
  , ypad ∷ ValueOrBinding Number
  | r
  )


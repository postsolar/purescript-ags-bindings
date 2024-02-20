module Gtk.Misc where

import AGS.Binding (ValueOrBinding)

type GtkMiscProps r =
  ( xalign ∷ ValueOrBinding Number
  , xpad ∷ ValueOrBinding Number
  , yalign ∷ ValueOrBinding Number
  , ypad ∷ ValueOrBinding Number
  | r
  )


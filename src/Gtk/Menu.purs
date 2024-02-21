module Gtk.Menu where

import AGS.Binding (ValueOrBinding)

-- Type parameter `a` is implied to be `Gtk.Widget` or anything that extends it
type GtkMenuProps a r =
  ( -- accelGroup ∷ ValueOrBinding Gtk.AccelGroup
    accelPath ∷ ValueOrBinding String
  , active ∷ ValueOrBinding Number
  --, anchorHints ∷ ValueOrBinding Gdk.AnchorHints
  , attachWidget ∷ ValueOrBinding a
  --, menuTypeHint ∷ ValueOrBinding Gdk.WindowTypeHint
  , monitor ∷ ValueOrBinding Number
  , rectAnchorDx ∷ ValueOrBinding Number
  , rectAnchorDy ∷ ValueOrBinding Number
  , reserveToggleSize ∷ ValueOrBinding Boolean
  , tearoffSAte ∷ ValueOrBinding Boolean
  , tearoffTTle ∷ ValueOrBinding String
  | r
  )


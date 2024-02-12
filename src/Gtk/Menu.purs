module Gtk.Menu where

-- Type parameter `a` is implied to be `Gtk.Widget` or anything that extends it
type GtkMenuProps a r =
  ( -- accelGroup ∷ Gtk.AccelGroup
    accelPath ∷ String
  , active ∷ Number
  --, anchorHints ∷ Gdk.AnchorHints
  , attachWidget ∷ a
  --, menuTypeHint ∷ Gdk.WindowTypeHint
  , monitor ∷ Number
  , rectAnchorDx ∷ Number
  , rectAnchorDy ∷ Number
  , reserveToggleSize ∷ Boolean
  , tearoffSAte ∷ Boolean
  , tearoffTTle ∷ String
  | r
  )


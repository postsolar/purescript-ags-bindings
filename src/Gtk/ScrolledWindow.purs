module Gtk.ScrolledWindow where

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.scrolledwindow
-- Inherited: Gtk.Widget (39), Gtk.Container (3)
type GtkScrolledWindowProps r =
  ( -- hadjustment ∷ Gtk.Adjustment
    -- hscrollbarPolicy ∷ Gtk.PolicyType
    kineticScrolling ∷ Boolean
  , maxContentHeight ∷ Number
  , maxContentWidth ∷ Number
  , minContentHeight ∷ Number
  , minContentWidth ∷ Number
  , overlayScrolling ∷ Boolean
  , propagateNaturalHeight ∷ Boolean
  , propagateNaturalWidth ∷ Boolean
  -- , shadowType ∷ Gtk.ShadowType
  -- , vadjustment ∷ Gtk.Adjustment
  -- , vscrollbarPolicy ∷ Gtk.PolicyType
  -- , windowPlacement ∷ Gtk.CornerType
  , windowPlacementSet ∷ Boolean
  | r
  )


module Gtk.ScrolledWindow where

import AGS.Binding (ValueOrBinding)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.scrolledwindow
-- Inherited: Gtk.Widget (39), Gtk.Container (3)
type GtkScrolledWindowProps r =
  ( -- hadjustment ∷ ValueOrBinding Gtk.Adjustment
    -- hscrollbarPolicy ∷ ValueOrBinding Gtk.PolicyType
    kineticScrolling ∷ ValueOrBinding Boolean
  , maxContentHeight ∷ ValueOrBinding Number
  , maxContentWidth ∷ ValueOrBinding Number
  , minContentHeight ∷ ValueOrBinding Number
  , minContentWidth ∷ ValueOrBinding Number
  , overlayScrolling ∷ ValueOrBinding Boolean
  , propagateNaturalHeight ∷ ValueOrBinding Boolean
  , propagateNaturalWidth ∷ ValueOrBinding Boolean
  -- , shadowType ∷ ValueOrBinding Gtk.ShadowType
  -- , vadjustment ∷ ValueOrBinding Gtk.Adjustment
  -- , vscrollbarPolicy ∷ ValueOrBinding Gtk.PolicyType
  -- , windowPlacement ∷ ValueOrBinding Gtk.CornerType
  , windowPlacementSet ∷ ValueOrBinding Boolean
  | r
  )


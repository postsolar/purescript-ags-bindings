module Gtk.Actionable where

import AGS.Binding (ValueOrBinding)

type GtkActionableProps r =
  ( actionName ∷ ValueOrBinding String
  -- , actionTarget ∷ GLib.Variant
  | r
  )


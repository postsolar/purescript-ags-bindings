module Gtk.Box where

import AGS.Binding (ValueOrBinding)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.box
-- Inherited: Gtk.Orientable (1), Gtk.Widget (39), Gtk.Container (3)
type GtkBoxProps r =
  ( -- baselinePosition ∷ Gtk.BaselinePosition
    homogeneous ∷ ValueOrBinding Boolean
  , spacing ∷ ValueOrBinding Number
  | r
  )


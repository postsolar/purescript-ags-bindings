module Gtk.Container where

import AGS.Binding (ValueOrBinding)
import Gtk.Widget (Widget)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.container
-- Inherited: Gtk.Widget (39)
type GtkContainerProps r =
  ( borderWidth ∷ ValueOrBinding Number
  , child ∷ ValueOrBinding Widget
  -- , resizeMode ∷ Gtk.ResizeMode
  | r
  )


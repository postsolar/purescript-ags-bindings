module Gtk.Container where

import AGS.Binding (SelfOrBinding)
import Gtk.Widget (Widget)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.container
-- Inherited: Gtk.Widget (39)
type GtkContainerProps r =
  ( borderWidth ∷ Number
  , child ∷ SelfOrBinding Widget
  -- , resizeMode ∷ Gtk.ResizeMode
  | r
  )


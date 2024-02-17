module Gtk.Button where

import AGS.Binding (ValueOrBinding)
import Gtk.Widget (Widget)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.button
-- Inherited: GObject.Object (1), Gtk.Widget (69), Gtk.Container (4)
type GtkButtonProps r =
  ( alwaysShowImage ∷ Boolean
  , image ∷ ValueOrBinding Widget
  -- , imagePosition ∷ Gtk.PositionType
  , label ∷ String
  -- , relief ∷ Gtk.ReliefStyle
  , useStock ∷ Boolean
  , useUnderline ∷ Boolean
  , xalign ∷ Number
  , yalign ∷ Number
  | r
  )


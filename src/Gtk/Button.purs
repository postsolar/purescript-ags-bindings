module Gtk.Button where

import AGS.Binding (ValueOrBinding)
import Gtk.Widget (Widget)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.button
-- Inherited: GObject.Object (1), Gtk.Widget (69), Gtk.Container (4)
type GtkButtonProps r =
  ( alwaysShowImage ∷ ValueOrBinding Boolean
  , image ∷ ValueOrBinding Widget
  -- , imagePosition ∷ Gtk.PositionType
  , label ∷ ValueOrBinding String
  -- , relief ∷ ValueOrBinding Gtk.ReliefStyle
  , useStock ∷ ValueOrBinding Boolean
  , useUnderline ∷ ValueOrBinding Boolean
  , xalign ∷ ValueOrBinding Int
  , yalign ∷ ValueOrBinding Int
  | r
  )


module Gtk.Label where

import AGS.Binding (ValueOrBinding)
import Gtk.Widget (Widget)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.label
-- Inherited: Gtk.Widget (39), Gtk.Misc (4)
type GtkLabelProps r =
  ( angle ∷ ValueOrBinding Number
  -- , attributes ∷ ValueOrBinding Pango.AttrList
  , cursorPosition ∷ ValueOrBinding Number
  -- , ellipsize ∷ ValueOrBinding Pango.EllipsizeMode
  -- , justify ∷ ValueOrBinding Gtk.Justification
  , label ∷ ValueOrBinding String
  , lines ∷ ValueOrBinding Number
  , maxWidthChars ∷ ValueOrBinding Number
  , mnemonicKeyval ∷ ValueOrBinding Number
  , mnemonicWidget ∷ ValueOrBinding Widget
  , pattern ∷ ValueOrBinding String
  , selectable ∷ ValueOrBinding Boolean
  , selectionBound ∷ ValueOrBinding Number
  , singleLineMode ∷ ValueOrBinding Boolean
  , trackVisitedLinks ∷ ValueOrBinding Boolean
  , useMarkup ∷ ValueOrBinding Boolean
  , useUnderline ∷ ValueOrBinding Boolean
  , widthChars ∷ ValueOrBinding Number
  , wrap ∷ ValueOrBinding Boolean
  -- , wrapMode ∷ ValueOrBinding Pango.WrapMode
  , xalign ∷ ValueOrBinding Number
  , yalign ∷ ValueOrBinding Number
  | r
  )


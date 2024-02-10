module Gtk.Label where

import AGS.Widget (SelfOrBinding, Widget)

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.label
-- Inherited: Gtk.Widget (39), Gtk.Misc (4)
type GtkLabelProps r =
  ( angle ∷ Number
  -- , attributes ∷ Pango.AttrList
  , cursorPosition ∷ Number
  -- , ellipsize ∷ Pango.EllipsizeMode
  -- , justify ∷ Gtk.Justification
  , label ∷ SelfOrBinding String
  , lines ∷ Number
  , maxWidthChars ∷ Number
  , mnemonicKeyval ∷ Number
  , mnemonicWidget ∷ SelfOrBinding Widget
  , pattern ∷ String
  , selectable ∷ Boolean
  , selectionBound ∷ Number
  , singleLineMode ∷ Boolean
  , trackVisitedLinks ∷ Boolean
  , useMarkup ∷ Boolean
  , useUnderline ∷ Boolean
  , widthChars ∷ Number
  , wrap ∷ Boolean
  -- , wrapMode ∷ Pango.WrapMode
  , xalign ∷ Number
  , yalign ∷ Number
  | r
  )

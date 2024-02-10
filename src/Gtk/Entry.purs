module Gtk.Entry where

-- https://gjs-docs.gnome.org/gtk30~3.0/gtk.entry
-- Inherited: Gtk.CellEditable (1), Gtk.Widget (39)
type GtkEntryProps r =
  ( activatesDefault ∷ Boolean
  -- , attributes ∷ Pango.AttrList
  -- , buffer ∷ Gtk.EntryBuffer
  , capsLockWarning ∷ Boolean
  -- , completion ∷ Gtk.EntryCompletion
  , cursorPosition ∷ Number
  , editable ∷ Boolean
  , enableEmojiCompletion ∷ Boolean
  , hasFrame ∷ Boolean
  , imModule ∷ String
  -- , innerBorder ∷ Gtk.Border
  -- , inputHints ∷ Gtk.InputHints
  -- , inputPurpose ∷ Gtk.InputPurpose
  , invisibleChar ∷ Number
  , invisibleCharSet ∷ Boolean
  , maxLength ∷ Number
  , maxWidthChars ∷ Number
  , overwriteMode ∷ Boolean
  , placeholderText ∷ String
  , populateAll ∷ Boolean
  , primaryIconActivatable ∷ Boolean
  -- , primaryIconGicon ∷ Gio.Icon
  , primaryIconName ∷ String
  -- , primaryIconPixbuf ∷ GdkPixbuf.Pixbuf
  , primaryIconSensitive ∷ Boolean
  , primaryIconStock ∷ String
  -- , primaryIconStorageType ∷ Gtk.ImageType
  , primaryIconTooltipMarkup ∷ String
  , primaryIconTooltipText ∷ String
  , progressFraction ∷ Number
  , progressPulseStep ∷ Number
  , scrollOffset ∷ Number
  , secondaryIconActivatable ∷ Boolean
  -- , secondaryIconGicon ∷ Gio.Icon
  , secondaryIconName ∷ String
  -- , secondaryIconPixbuf ∷ GdkPixbuf.Pixbuf
  , secondaryIconSensitive ∷ Boolean
  , secondaryIconStock ∷ String
  -- , secondaryIconStorageType ∷ Gtk.ImageType
  , secondaryIconTooltipMarkup ∷ String
  , secondaryIconTooltipText ∷ String
  , selectionBound ∷ Number
  -- , shadowType ∷ Gtk.ShadowType
  , showEmojiIcon ∷ Boolean
  -- , tabs ∷ Pango.TabArray
  , text ∷ String
  , textLength ∷ Number
  , truncateMultiline ∷ Boolean
  , visibility ∷ Boolean
  , widthChars ∷ Number
  , xalign ∷ Number
  | r
  )


module Gtk.Widget where

data Widget

type GtkWidgetProps r =
  ( appPaintable ∷ Boolean
  , canDefault ∷ Boolean
  , canFocus ∷ Boolean
  , compositeChild ∷ Boolean
  , doubleBuffered ∷ Boolean
  -- , events ∷ Gdk.EventMask
  , expand ∷ Boolean
  , focusOnClick ∷ Boolean
  -- , halign ∷ Gtk.Align
  , hasDefault ∷ Boolean
  , hasFocus ∷ Boolean
  , hasTooltip ∷ Boolean
  , heightRequest ∷ Number
  , hexpand ∷ Boolean
  , hexpandSet ∷ Boolean
  , isFocus ∷ Boolean
  , margin ∷ Number
  , marginBottom ∷ Number
  , marginEnd ∷ Number
  , marginLeft ∷ Number
  , marginRight ∷ Number
  , marginStart ∷ Number
  , marginTop ∷ Number
  , name ∷ String
  , noShowAll ∷ Boolean
  , opacity ∷ Number
  -- , parent ∷ Gtk.Container
  , receivesDefault ∷ Boolean
  , scaleFactor ∷ Number
  , sensitive ∷ Boolean
  -- , style ∷ Gtk.Style
  , tooltipMarkup ∷ String
  , tooltipText ∷ String
  -- , valign ∷ Gtk.Align
  , vexpand ∷ Boolean
  , vexpandSet ∷ Boolean
  , visible ∷ Boolean
  , widthRequest ∷ Number
  -- , window ∷ Gdk.Window
  | r
  )


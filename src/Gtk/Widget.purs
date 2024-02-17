module Gtk.Widget where

import AGS.Binding (ValueOrBinding)

data Widget

type GtkWidgetProps r =
  ( appPaintable ∷ ValueOrBinding Boolean
  , canDefault ∷ ValueOrBinding Boolean
  , canFocus ∷ ValueOrBinding Boolean
  , compositeChild ∷ ValueOrBinding Boolean
  , doubleBuffered ∷ ValueOrBinding Boolean
  -- , events ∷ Gdk.EventMask
  , expand ∷ ValueOrBinding Boolean
  , focusOnClick ∷ ValueOrBinding Boolean
  -- , halign ∷ Gtk.Align
  , hasDefault ∷ ValueOrBinding Boolean
  , hasFocus ∷ ValueOrBinding Boolean
  , hasTooltip ∷ ValueOrBinding Boolean
  , heightRequest ∷ ValueOrBinding Number
  , hexpand ∷ ValueOrBinding Boolean
  , hexpandSet ∷ ValueOrBinding Boolean
  , isFocus ∷ ValueOrBinding Boolean
  , margin ∷ ValueOrBinding Number
  , marginBottom ∷ ValueOrBinding Number
  , marginEnd ∷ ValueOrBinding Number
  , marginLeft ∷ ValueOrBinding Number
  , marginRight ∷ ValueOrBinding Number
  , marginStart ∷ ValueOrBinding Number
  , marginTop ∷ ValueOrBinding Number
  , name ∷ ValueOrBinding String
  , noShowAll ∷ ValueOrBinding Boolean
  , opacity ∷ ValueOrBinding Number
  -- , parent ∷ Gtk.Container
  , receivesDefault ∷ ValueOrBinding Boolean
  , scaleFactor ∷ ValueOrBinding Number
  , sensitive ∷ ValueOrBinding Boolean
  -- , style ∷ Gtk.Style
  , tooltipMarkup ∷ ValueOrBinding String
  , tooltipText ∷ ValueOrBinding String
  -- , valign ∷ Gtk.Align
  , vexpand ∷ ValueOrBinding Boolean
  , vexpandSet ∷ ValueOrBinding Boolean
  , visible ∷ ValueOrBinding Boolean
  , widthRequest ∷ ValueOrBinding Number
  -- , window ∷ Gdk.Window
  | r
  )


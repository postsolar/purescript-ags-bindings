module Gtk.Widget where

import AGS.Binding (SelfOrBinding)

data Widget

type GtkWidgetProps r =
  ( appPaintable ∷ SelfOrBinding Boolean
  , canDefault ∷ SelfOrBinding Boolean
  , canFocus ∷ SelfOrBinding Boolean
  , compositeChild ∷ SelfOrBinding Boolean
  , doubleBuffered ∷ SelfOrBinding Boolean
  -- , events ∷ Gdk.EventMask
  , expand ∷ SelfOrBinding Boolean
  , focusOnClick ∷ SelfOrBinding Boolean
  -- , halign ∷ Gtk.Align
  , hasDefault ∷ SelfOrBinding Boolean
  , hasFocus ∷ SelfOrBinding Boolean
  , hasTooltip ∷ SelfOrBinding Boolean
  , heightRequest ∷ SelfOrBinding Number
  , hexpand ∷ SelfOrBinding Boolean
  , hexpandSet ∷ SelfOrBinding Boolean
  , isFocus ∷ SelfOrBinding Boolean
  , margin ∷ SelfOrBinding Number
  , marginBottom ∷ SelfOrBinding Number
  , marginEnd ∷ SelfOrBinding Number
  , marginLeft ∷ SelfOrBinding Number
  , marginRight ∷ SelfOrBinding Number
  , marginStart ∷ SelfOrBinding Number
  , marginTop ∷ SelfOrBinding Number
  , name ∷ SelfOrBinding String
  , noShowAll ∷ SelfOrBinding Boolean
  , opacity ∷ SelfOrBinding Number
  -- , parent ∷ Gtk.Container
  , receivesDefault ∷ SelfOrBinding Boolean
  , scaleFactor ∷ SelfOrBinding Number
  , sensitive ∷ SelfOrBinding Boolean
  -- , style ∷ Gtk.Style
  , tooltipMarkup ∷ SelfOrBinding String
  , tooltipText ∷ SelfOrBinding String
  -- , valign ∷ Gtk.Align
  , vexpand ∷ SelfOrBinding Boolean
  , vexpandSet ∷ SelfOrBinding Boolean
  , visible ∷ SelfOrBinding Boolean
  , widthRequest ∷ SelfOrBinding Number
  -- , window ∷ Gdk.Window
  | r
  )


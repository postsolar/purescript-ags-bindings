module Gtk.Image where

import AGS.Binding (ValueOrBinding)

type GtkImageProps r =
  ( file ∷ ValueOrBinding String
  -- , gicon ∷ ValueOrBinding Gio.Icon
  , iconName ∷ ValueOrBinding String
  -- , iconSet ∷ ValueOrBinding Gtk.IconSet
  , iconSize ∷ ValueOrBinding Number
  -- , pixbuf ∷ ValueOrBinding GdkPixbuf.Pixbuf
  -- , pixbufAnimation ∷ ValueOrBinding GdkPixbuf.PixbufAnimation
  , pixelSize ∷ ValueOrBinding Number
  , resource ∷ ValueOrBinding String
  , stock ∷ ValueOrBinding String
  -- , storageType ∷ ValueOrBinding Gtk.ImageType
  -- , surface ∷ ValueOrBinding Cairo.Surface
  , useFallback ∷ ValueOrBinding Boolean
  | r
  )


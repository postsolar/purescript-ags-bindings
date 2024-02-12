module Gtk.Image where

type GtkImageProps r =
  ( file ∷ String
  -- , gicon ∷ Gio.Icon
  , iconName ∷ String
  -- , iconSet ∷ Gtk.IconSet
  , iconSize ∷ Number
  -- , pixbuf ∷ GdkPixbuf.Pixbuf
  -- , pixbufAnimation ∷ GdkPixbuf.PixbufAnimation
  , pixelSize ∷ Number
  , resource ∷ String
  , stock ∷ String
  -- , storageType ∷ Gtk.ImageType
  -- , surface ∷ Cairo.Surface
  , useFallback ∷ Boolean
  | r
  )


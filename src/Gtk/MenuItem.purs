module Gtk.MenuItem where

-- The type parameter `a` is implied to be `Gtk.Menu` or anything that extends it
type GtkMenuItemProps a r =
  ( accelPath ∷ String
  , label ∷ String
  , rightJustified ∷ Boolean
  , submenu ∷ a
  , useUnderline ∷ Boolean
  | r
  )


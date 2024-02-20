module Gtk.MenuItem where

import AGS.Binding (ValueOrBinding)

-- The type parameter `a` is implied to be `Gtk.Menu` or anything that extends it
type GtkMenuItemProps a r =
  ( accelPath ∷ ValueOrBinding String
  , label ∷ ValueOrBinding String
  , rightJustified ∷ ValueOrBinding Boolean
  , submenu ∷ ValueOrBinding a
  , useUnderline ∷ ValueOrBinding Boolean
  | r
  )


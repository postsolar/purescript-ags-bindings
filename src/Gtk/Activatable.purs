module Gtk.Activatable where

import AGS.Binding (ValueOrBinding)

type GtkActivatableProps r =
  ( -- relatedAction ∷ Gtk.Action
    useActionAppearance ∷ ValueOrBinding Boolean
  | r
  )


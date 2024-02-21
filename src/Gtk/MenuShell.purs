module Gtk.MenuShell where

import AGS.Binding (ValueOrBinding)

type GtkMenuShellProps r =
  ( takeFocus ∷ ValueOrBinding Boolean
  | r
  )


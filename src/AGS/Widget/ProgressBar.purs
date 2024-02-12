module AGS.Widget.ProgressBar
  ( ProgressBarProps
  , progressBar
  ) where

import AGS.Widget (AGSWidgetProps, Widget)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.ProgressBar (GtkProgressBarProps)
import Prelude ((<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type ProgressBarProps r =
  AGSWidgetProps
    + GtkOrientableProps
    + GtkProgressBarProps
    +
      ( vertical ∷ Boolean
      , value ∷ Number
      | r
      )

progressBar ∷ ∀ r r'. Union r r' (ProgressBarProps ()) ⇒ Record r → Widget
progressBar = progressBarImpl <<< unsafeCoerce

foreign import progressBarImpl ∷ Record (ProgressBarProps ()) → Widget


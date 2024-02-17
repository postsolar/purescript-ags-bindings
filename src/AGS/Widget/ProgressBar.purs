module AGS.Widget.ProgressBar
  ( ProgressBarProps
  , UpdateProgressBarProps
  , progressBar
  , progressBar'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Orientable (GtkOrientableProps)
import Gtk.ProgressBar (GtkProgressBarProps)
import Gtk.Widget (Widget)
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

type UpdateProgressBarProps =
  Record (ProgressBarProps ()) → Record (ProgressBarProps ())

progressBar'
  ∷ ∀ r r'
  . Union r r' (ProgressBarProps ())
  ⇒ Record r
  → Widget /\ (UpdateProgressBarProps → Effect Unit)
progressBar' props =
  let
    widget = progressBar props
    update = unsafeWidgetUpdate @(ProgressBarProps ()) widget
  in
    widget /\ update


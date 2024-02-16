module AGS.Widget.Overlay
  ( OverlayProps
  , overlay
  ) where

import AGS.Widget.Internal (AGSWidgetProps)
import Gtk.Widget (Widget)
import Prelude ((<<<))
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type OverlayProps r =
  AGSWidgetProps
    +
      ( child ∷ Widget
      , overlays ∷ Array Widget
      , passThrough ∷ Boolean
      | r
      )

overlay ∷ ∀ r r'. Union r r' (OverlayProps ()) ⇒ Record r → Widget
overlay = overlayImpl <<< unsafeCoerce

foreign import overlayImpl ∷ Record (OverlayProps ()) → Widget


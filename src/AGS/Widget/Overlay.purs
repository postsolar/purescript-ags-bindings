module AGS.Widget.Overlay
  ( OverlayProps
  , UpdateOverlayProps
  , overlay
  , overlay'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Gtk.Widget (Widget)
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

type UpdateOverlayProps = Record (OverlayProps ()) → Record (OverlayProps ())

overlay'
  ∷ ∀ r r'
  . Union r r' (OverlayProps ())
  ⇒ Record r
  → Widget /\ (UpdateOverlayProps → Effect Unit)
overlay' props =
  let
    widget = overlay props
    update = unsafeWidgetUpdate @(OverlayProps ()) widget
  in
    widget /\ update


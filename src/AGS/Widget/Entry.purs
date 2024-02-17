module AGS.Widget.Entry
  ( EntryProps
  , UpdateEntryProps
  , entry
  , entry'
  ) where

import Prelude

import AGS.Widget.Internal (AGSWidgetProps, unsafeWidgetUpdate)
import Data.Tuple.Nested (type (/\), (/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Gtk.Entry (GtkEntryProps)
import Gtk.Widget (Widget)
import Prim.Row (class Union)
import Type.Row (type (+))
import Unsafe.Coerce (unsafeCoerce)

type EntryProps r =
  AGSWidgetProps
    + GtkEntryProps
    +
      ( onChange ∷ EffectFn1 Widget Unit
      , onAccept ∷ EffectFn1 Widget Unit
      | r
      )

entry ∷ ∀ r r'. Union r r' (EntryProps ()) ⇒ Record r → Widget
entry = entryImpl <<< unsafeCoerce

foreign import entryImpl ∷ Record (EntryProps ()) → Widget

type UpdateEntryProps = Record (EntryProps ()) → Record (EntryProps ())

entry'
  ∷ ∀ r r'
  . Union r r' (EntryProps ())
  ⇒ Record r
  → Widget /\ (UpdateEntryProps → Effect Unit)
entry' props =
  let
    widget = entry props
    update = unsafeWidgetUpdate @(EntryProps ()) widget
  in
    widget /\ update


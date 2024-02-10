module AGS.Widget.Entry
  ( EntryProps
  , entry
  ) where

import Prelude

import AGS.Widget (AGSWidgetProps, Widget)
import Effect.Uncurried (EffectFn1)
import Gtk.Entry (GtkEntryProps)
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


module AGS.Widget.Entry (EntryProps, entry, entry') where

import Prelude

import AGS.Widget.Internal
  ( AGSWidgetProps
  , MkWidget
  , MkWidgetWithUpdates
  , mkWidgetWithUpdates
  , propsToValueOrBindings
  )
import Effect.Uncurried (EffectFn1)
import Gtk.Entry (GtkEntryProps)
import Gtk.Widget (Widget)
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

entry ∷ MkWidget (EntryProps ())
entry = entryImpl <<< unsafeCoerce <<< propsToValueOrBindings @(EntryProps ())

entry' ∷ MkWidgetWithUpdates (EntryProps ())
entry' = mkWidgetWithUpdates entry

foreign import entryImpl ∷ Record (EntryProps ()) → Widget


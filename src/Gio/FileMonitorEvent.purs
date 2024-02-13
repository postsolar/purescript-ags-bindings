module Gio.FileMonitorEvent where

foreign import data GioFileMonitorEvent ∷ Type

foreign import attributeChanged ∷ GioFileMonitorEvent
foreign import changed ∷ GioFileMonitorEvent
foreign import changesDoneHint ∷ GioFileMonitorEvent
foreign import created ∷ GioFileMonitorEvent
foreign import deleted ∷ GioFileMonitorEvent
foreign import moved ∷ GioFileMonitorEvent
foreign import movedIn ∷ GioFileMonitorEvent
foreign import movedOut ∷ GioFileMonitorEvent
foreign import preUnmount ∷ GioFileMonitorEvent
foreign import renamed ∷ GioFileMonitorEvent
foreign import unmounted ∷ GioFileMonitorEvent


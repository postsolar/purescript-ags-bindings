module Gio.FileMonitorFlags where

foreign import data GioFileMonitorFlags ∷ Type

foreign import none ∷ GioFileMonitorFlags
foreign import sendMoved ∷ GioFileMonitorFlags
foreign import watchHardLinks ∷ GioFileMonitorFlags
foreign import watchMounts ∷ GioFileMonitorFlags
foreign import watchMoves ∷ GioFileMonitorFlags


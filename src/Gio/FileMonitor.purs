module Gio.FileMonitor where

import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried
  ( EffectFn1
  , EffectFn2
  , EffectFn4
  , runEffectFn1
  , runEffectFn2
  )
import GObject (class GObjectSignal, unsafeConnect)
import Gio.File (GioFile)
import Gio.FileMonitorEvent (GioFileMonitorEvent)
import Gio.FileMonitorFlags (GioFileMonitorFlags)
import Unsafe.Coerce (unsafeCoerce)

foreign import data GioFileMonitor ∷ Type

-- * Signals

type OnChangeCallback =
  EffectFn4 GioFileMonitor GioFile GioFile GioFileMonitorEvent Unit

instance
  GObjectSignal "changed"
    GioFileMonitor
    OnChangeCallback where
  connect cb mon = unsafeConnect @"changed" cb mon

instance
  GObjectSignal "notify::cancelled"
    GioFileMonitor
    (EffectFn1 GioFileMonitor Unit) where
  connect cb mon = unsafeConnect @"notify::cancelled" cb mon

-- * Methods

-- | Monitor a file or directory.
monitor ∷ GioFileMonitorFlags → GioFile → Effect (Nullable GioFileMonitor)
monitor = runEffectFn2 monitorImpl

-- | Monitor a file.
monitorFile ∷ GioFileMonitorFlags → GioFile → Effect (Nullable GioFileMonitor)
monitorFile = runEffectFn2 monitorFileImpl

-- | Monitor a directory.
monitorDirectory
  ∷ GioFileMonitorFlags → GioFile → Effect (Nullable GioFileMonitor)
monitorDirectory = runEffectFn2 monitorDirectoryImpl

foreign import monitorImpl
  ∷ EffectFn2 GioFileMonitorFlags GioFile (Nullable GioFileMonitor)

foreign import monitorFileImpl
  ∷ EffectFn2 GioFileMonitorFlags GioFile (Nullable GioFileMonitor)

foreign import monitorDirectoryImpl
  ∷ EffectFn2 GioFileMonitorFlags GioFile (Nullable GioFileMonitor)

-- | Register a `GioFileMonitor` so that it doesn't get deleted by GC.
registerMonitor ∷ GioFileMonitor → Effect Unit
registerMonitor = runEffectFn1 registerMonitorImpl

foreign import registerMonitorImpl ∷ EffectFn1 GioFileMonitor Unit

-- | Cancel a file monitor.
foreign import cancel ∷ GioFileMonitor → Effect Unit

-- | Check if a file monitor is cancelled.
isCanceled ∷ GioFileMonitor → Effect Boolean
isCanceled = unsafeCoerce _.is_cancelled


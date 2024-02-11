module AGS.Service.App
  ( configDir
  , windows
  , App
  , AppSignal(..)
  , addWindow
  , removeWindow
  , closeWindow
  , openWindow
  , toggleWindow
  , quit
  , resetCss
  , applyCss
  , getWindow
  ) where

import Prelude

import AGS.Service (class ConnectService, Service)
import AGS.Widget.Window (Window)
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn2)
import GObject
  ( class ToSignal
  , HandlerID
  , SignalHandler
  , mkSignalHandler
  , withSignal
  )
import Untagged.Union (UndefinedOr, uorToMaybe)

foreign import data App ∷ Service

-- * Props

foreign import configDir ∷ Effect String
foreign import windows ∷ Effect (Array Window)

-- * Signals

data AppSignal
  = ConfigParsed (Effect Unit)
  | WindowToggled ({ windowName ∷ String, visible ∷ Boolean } → Effect Unit)

instance ToSignal AppSignal where
  toSignal = case _ of
    ConfigParsed f →
      { handler: mkSignalHandler f
      , signal: "config-parsed"
      }
    WindowToggled f →
      { handler: mkSignalHandler $
          mkEffectFn2 \windowName visible → f { windowName, visible }
      , signal: "window-toggled"
      }

instance ConnectService App AppSignal where
  connectService = withSignal connectApp

foreign import connectApp ∷ SignalHandler → String → Effect HandlerID

-- * Methods

foreign import addWindow ∷ Window → Effect Unit
foreign import removeWindow ∷ Window → Effect Unit

foreign import closeWindow ∷ String → Effect Unit
foreign import openWindow ∷ String → Effect Unit
foreign import toggleWindow ∷ String → Effect Unit

foreign import quit ∷ Effect Unit
foreign import resetCss ∷ Effect Unit
foreign import applyCss ∷ String → Effect Unit

getWindow ∷ String → Effect (Maybe Window)
getWindow = map uorToMaybe <<< getWindowImpl

foreign import getWindowImpl ∷ String → Effect (UndefinedOr Window)


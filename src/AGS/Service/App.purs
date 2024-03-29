module AGS.Service.App
  ( App
  , AppSignals
  , disconnectApp
  , addWindow
  , applyCss
  , closeWindow
  , configDir
  , getWindow
  , openWindow
  , quit
  , removeWindow
  , resetCss
  , toggleWindow
  , windows
  ) where

import Prelude

import AGS.Service (class ServiceConnect, Service)
import AGS.Widget.Window (Window)
import Data.Maybe (Maybe)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import GObject (HandlerID)
import Type.Proxy (Proxy(..))
import Untagged.Union (UndefinedOr, uorToMaybe)

foreign import data App ∷ Service

-- * Props

foreign import iconTheme ∷ Effect String
foreign import cursorTheme ∷ Effect String
foreign import gtkTheme ∷ Effect String
foreign import configPath ∷ Effect String
foreign import configDir ∷ Effect String
foreign import windows ∷ Effect (Array Window)

-- * Signals

type AppSignals =
  ( "config-parsed" ∷ Effect Unit
  , "window-toggled" ∷ EffectFn2 String Boolean Unit
  )

instance IsSymbol prop ⇒ ServiceConnect App prop AppSignals cb where
  connectService = connectApp (reflectSymbol (Proxy @prop))

foreign import disconnectApp ∷ HandlerID App → Effect Unit
foreign import connectApp ∷ ∀ f. String → f → Effect (HandlerID App)

-- * Methods

foreign import addIcons ∷ String → Effect Unit

foreign import setIconTheme ∷ String → Effect Unit
foreign import setCursorTheme ∷ String → Effect Unit
foreign import setGtkTheme ∷ String → Effect Unit

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


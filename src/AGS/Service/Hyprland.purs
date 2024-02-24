module AGS.Service.Hyprland
  ( HyprlandActiveRecord
  , Workspace'
  , Monitor
  , Client
  , Workspace
  , Active
  , Monitor'
  , Client'
  , Hyprland
  , HyprlandSignals
  , HyprlandServiceProps
  , HyprlandActive
  , HyprlandActiveSignals
  , HyprlandActiveServiceProps
  , disconnectHyprland
  , disconnectHyprlandActive
  , message
  , messageAsync
  , getMonitor
  , getWorkspace
  , getClient
  ) where

import Prelude

import AGS.Binding (Binding)
import AGS.Service (class BindServiceProp, class ServiceConnect, Service)
import Data.Maybe (Maybe)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2)
import GObject (HandlerID)
import Promise.Aff (Promise, toAffE)
import Type.Proxy (Proxy(..))
import Untagged.Union (UndefinedOr, uorToMaybe)

foreign import data Hyprland ∷ Service
foreign import data HyprlandActive ∷ Service

-- * Props and bindings

type HyprlandRecord =
  { active ∷ HyprlandActiveRecord
  , workspaces ∷ Array Workspace
  , monitors ∷ Array Monitor
  , clients ∷ Array Client
  }

type HyprlandActiveRecord =
  { monitor ∷ { id ∷ Int, name ∷ String }
  , workspace ∷ { id ∷ Int, name ∷ String }
  , client ∷ { address ∷ String, title ∷ String, class ∷ String }
  }

type Workspace' =
  { id ∷ Int
  , name ∷ String
  }

type Monitor =
  { activeWorkspace ∷ Workspace'
  , activelyTearing ∷ Boolean
  , description ∷ String
  , dpmsStatus ∷ Boolean
  , focused ∷ Boolean
  , height ∷ Int
  , id ∷ Int
  , make ∷ String
  , model ∷ String
  , name ∷ String
  , refreshRate ∷ Number
  , reserved ∷ Array Int
  , scale ∷ Number
  , serial ∷ String
  , specialWorkspace ∷ Workspace'
  , transform ∷ Int
  , vrr ∷ Boolean
  , width ∷ Int
  , x ∷ Int
  , y ∷ Int
  }

type Client =
  { address ∷ String
  , at ∷ Array Int
  , class ∷ String
  , fakeFullscreen ∷ Boolean
  , floating ∷ Boolean
  , focusHistoryID ∷ Int
  , fullscreen ∷ Boolean
  , fullscreenMode ∷ Int
  , hidden ∷ Boolean
  , initialClass ∷ String
  , initialTitle ∷ String
  , mapped ∷ Boolean
  , monitor ∷ Int
  , pid ∷ Int
  , pinned ∷ Boolean
  , size ∷ Array Int
  , swallowing ∷ String
  , title ∷ String
  , workspace ∷ Workspace'
  , xwayland ∷ Boolean
  }

type Workspace =
  { hasfullscreen ∷ Boolean
  , id ∷ Int
  , lastwindow ∷ String
  , lastwindowtitle ∷ String
  , monitor ∷ String
  , monitorID ∷ Int
  , name ∷ String
  , windows ∷ Int
  }

type Active =
  { monitor ∷ Monitor'
  , workspace ∷ Workspace'
  , client ∷ Client'
  }

type Monitor' =
  { id ∷ Int
  , name ∷ String
  }

type Client' =
  { address ∷ String
  , title ∷ String
  , class ∷ String
  }

type HyprlandServiceProps =
  ( active ∷ HyprlandActiveRecord
  , monitors ∷ Array Monitor
  , workspaces ∷ Array Workspace
  , clients ∷ Array Client
  )

instance IsSymbol prop ⇒ BindServiceProp Hyprland prop HyprlandServiceProps ty where
  bindServiceProp = bindHyprland (reflectSymbol (Proxy @"prop"))

foreign import bindHyprland ∷ ∀ a. String → Effect (Binding a)

type HyprlandActiveServiceProps =
  ( client ∷ Client'
  , workspace ∷ Workspace'
  , monitor ∷ Monitor'
  )

instance
  IsSymbol prop ⇒
  BindServiceProp HyprlandActive prop HyprlandActiveServiceProps ty where
  bindServiceProp = bindHyprlandActive (reflectSymbol (Proxy @"prop"))

foreign import bindHyprlandActive ∷ ∀ a. String → Effect (Binding a)

-- * Signals

foreign import disconnectHyprland ∷ HandlerID Hyprland → Effect Unit
foreign import disconnectHyprlandActive ∷ HandlerID HyprlandActive → Effect Unit

type HyprlandSignals =
  ( event ∷ EffectFn2 String String Unit
  , "urgent-window" ∷ EffectFn1 Int Unit
  , "keyboard-layout" ∷ EffectFn2 String String Unit
  , submap ∷ EffectFn1 String Unit
  , "monitor-added" ∷ EffectFn1 Int Unit
  , "monitor-removed" ∷ EffectFn1 Int Unit
  , "workspace-added" ∷ EffectFn1 Int Unit
  , "workspace-removed" ∷ EffectFn1 Int Unit
  , "client-added" ∷ EffectFn1 String Unit
  , "client-removed" ∷ EffectFn1 String Unit
  , fullscreen ∷ EffectFn1 Boolean Unit
  , changed ∷ Effect Unit
  )

instance IsSymbol prop ⇒ ServiceConnect Hyprland prop HyprlandSignals cb where
  connectService = connectHyprland (reflectSymbol (Proxy @prop))

foreign import connectHyprland
  ∷ ∀ f. String → f → Effect (HandlerID Hyprland)

type HyprlandActiveSignals =
  ( changed ∷ Effect Unit
  )

instance
  IsSymbol prop ⇒
  ServiceConnect HyprlandActive prop HyprlandActiveSignals cb where
  connectService = connectHyprlandActive (reflectSymbol (Proxy @prop))

foreign import connectHyprlandActive
  ∷ ∀ f. String → f → Effect (HandlerID HyprlandActive)

-- * Methods

foreign import message ∷ String → Effect String

messageAsync ∷ String → Aff String
messageAsync = toAffE <<< messageAsyncImpl

foreign import messageAsyncImpl ∷ String → Effect (Promise String)

getMonitor ∷ Int → Effect (Maybe Monitor)
getMonitor = map uorToMaybe <<< getMonitorImpl

foreign import getMonitorImpl ∷ Int → Effect (UndefinedOr Monitor)

getWorkspace ∷ Int → Effect (Maybe Workspace)
getWorkspace = map uorToMaybe <<< getWorkspaceImpl

foreign import getWorkspaceImpl ∷ Int → Effect (UndefinedOr Workspace)

getClient ∷ String → Effect (Maybe Client)
getClient = map uorToMaybe <<< getClientImpl

foreign import getClientImpl ∷ String → Effect (UndefinedOr Client)


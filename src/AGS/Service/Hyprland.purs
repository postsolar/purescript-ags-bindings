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
  , HyprlandActive
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
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2)
import GObject (HandlerID)
import Promise.Aff (Promise, toAffE)
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

instance BindServiceProp Hyprland "active" HyprlandActiveRecord where
  bindServiceProp = bindHyprland "active"

instance BindServiceProp Hyprland "monitors" (Array Monitor) where
  bindServiceProp = bindHyprland "monitors"

instance BindServiceProp Hyprland "workspaces" (Array Workspace) where
  bindServiceProp = bindHyprland "workspaces"

instance BindServiceProp Hyprland "clients" (Array Client) where
  bindServiceProp = bindHyprland "clients"

foreign import bindHyprland ∷ ∀ a. String → Effect (Binding a)

instance BindServiceProp HyprlandActive "client" Client' where
  bindServiceProp = bindHyprlandActive "client"

instance BindServiceProp HyprlandActive "workspace" Workspace' where
  bindServiceProp = bindHyprlandActive "workspace"

instance BindServiceProp HyprlandActive "monitor" Monitor' where
  bindServiceProp = bindHyprlandActive "monitor"

foreign import bindHyprlandActive ∷ ∀ a. String → Effect (Binding a)

-- * Signals

foreign import disconnectHyprland ∷ HandlerID Hyprland → Effect Unit
foreign import disconnectHyprlandActive ∷ HandlerID HyprlandActive → Effect Unit

instance ServiceConnect Hyprland "event" (EffectFn2 String String Unit) where
  connectService = connectHyprland "event"

instance ServiceConnect Hyprland "urgent-window" (EffectFn1 Int Unit) where
  connectService = connectHyprland "urgent-window"

instance
  ServiceConnect Hyprland "keyboard-layout" (EffectFn2 String String Unit) where
  connectService = connectHyprland "keyboard-layout"

instance ServiceConnect Hyprland "submap" (EffectFn1 String Unit) where
  connectService = connectHyprland "submap"

instance ServiceConnect Hyprland "monitor-added" (EffectFn1 Int Unit) where
  connectService = connectHyprland "monitor-added"

instance ServiceConnect Hyprland "monitor-removed" (EffectFn1 Int Unit) where
  connectService = connectHyprland "monitor-removed"

instance ServiceConnect Hyprland "workspace-added" (EffectFn1 Int Unit) where
  connectService = connectHyprland "workspace-added"

instance ServiceConnect Hyprland "workspace-removed" (EffectFn1 Int Unit) where
  connectService = connectHyprland "workspace-removed"

instance ServiceConnect Hyprland "client-added" (EffectFn1 String Unit) where
  connectService = connectHyprland "client-added"

instance ServiceConnect Hyprland "client-removed" (EffectFn1 String Unit) where
  connectService = connectHyprland "client-removed"

instance ServiceConnect Hyprland "fullscreen" (EffectFn1 Boolean Unit) where
  connectService = connectHyprland "fullscreen"

instance ServiceConnect Hyprland "changed" (Effect Unit) where
  connectService = connectHyprland "changed"

foreign import connectHyprland
  ∷ ∀ f. String → f → Effect (HandlerID Hyprland)

instance ServiceConnect HyprlandActive "changed" (Effect Unit) where
  connectService = connectHyprlandActive "changed"

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


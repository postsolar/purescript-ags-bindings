module AGS.Service.Hyprland
  ( HyprlandActiveRecord
  , Workspace'
  , Monitor
  , Client
  , Workspace
  , Active
  , Monitor'
  , Client'
  , HyprlandSignal(..)
  , Hyprland
  , HyprlandActive
  , message
  , messageAsync
  , getMonitor
  , getWorkspace
  , getClient
  ) where

import Prelude

import AGS.Binding (Binding)
import AGS.Service (class BindServiceProp, class ConnectService, Service)
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (mkEffectFn1, mkEffectFn2)
import GObject
  ( class ToSignal
  , Changed
  , HandlerID
  , SignalHandler
  , mkSignalHandler
  , withSignal
  )
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

data HyprlandSignal
  = Event ({ name ∷ String, data ∷ String } → Effect Unit)
  | UrgentWindow (Int → Effect Unit)
  | KeyboardLayout
      ({ keyboardName ∷ String, layoutName ∷ String } → Effect Unit)
  | Submap (String → Effect Unit)
  | MonitorAdded (Int → Effect Unit)
  | MonitorRemoved (Int → Effect Unit)
  | WorkspaceAdded (Int → Effect Unit)
  | WorkspaceRemoved (Int → Effect Unit)
  | ClientAdded (String → Effect Unit)
  | ClientRemoved (String → Effect Unit)
  | Fullscreen (Boolean → Effect Unit)

instance ToSignal HyprlandSignal where
  toSignal = case _ of
    Event f →
      { handler: mkSignalHandler $
          mkEffectFn2 \name data' → f { name, data: data' }
      , signal: "event"
      }
    UrgentWindow f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "urgent-window"
      }
    KeyboardLayout f →
      { handler: mkSignalHandler $
          mkEffectFn2 \keyboardName layoutName →
            f { keyboardName, layoutName }
      , signal: "keyboard-layout"
      }
    Submap f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "submap"
      }
    MonitorAdded f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "monitor-added"
      }
    MonitorRemoved f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "monitor-removed"
      }
    WorkspaceAdded f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "workspace-added"
      }
    WorkspaceRemoved f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "workspace-removed"
      }
    ClientAdded f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "client-added"
      }
    ClientRemoved f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "client-removed"
      }
    Fullscreen f →
      { handler: mkSignalHandler $ mkEffectFn1 f
      , signal: "fullscreen"
      }

instance ConnectService Hyprland HyprlandSignal where
  connectService = withSignal connectHyprland

foreign import connectHyprland ∷ SignalHandler → String → Effect HandlerID

instance ConnectService HyprlandActive Changed where
  connectService = withSignal connectHyprlandActive

foreign import connectHyprlandActive ∷ SignalHandler → String → Effect HandlerID

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


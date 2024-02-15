module AGS.Service.Applications where

import Prelude

import AGS.Binding (Binding)
import AGS.Service (class BindServiceProp, Service)
import Data.Nullable (Nullable)
import Effect (Effect)
import Gio.DesktopAppInfo as Gio
import Unsafe.Coerce (unsafeCoerce)

foreign import data Applications ∷ Service
foreign import data Application ∷ Type

-- *** Applications

-- * Props and bindings

foreign import list ∷ Effect (Array Application)

foreign import bindApplications ∷ ∀ a. String → Effect (Binding a)

instance BindServiceProp Applications "list" (Array Application) where
  bindServiceProp = bindApplications "list"

-- * Methods

foreign import query ∷ String → Effect (Array Application)

-- *** Application

type ApplicationRecord =
  { app ∷ Gio.DesktopAppInfo
  , name ∷ String
  , desktop ∷ Nullable String
  , description ∷ Nullable String
  , executable ∷ String
  , "icon-name" ∷ String
  , frequency ∷ Int
  }

fromApplication ∷ Application → ApplicationRecord
fromApplication = unsafeCoerce

-- * Props and bindings

-- I have a hard time imagining why it would be
-- desired to bind into specific application's props.
-- Leaving unimplemented for now.

-- * Methods

foreign import launchApp ∷ Application → Effect Unit

foreign import matchAppName ∷ String → Application → Effect Boolean

foreign import reloadDesktopInfo ∷ Application → Effect Unit


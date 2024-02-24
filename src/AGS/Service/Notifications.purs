module AGS.Service.Notifications
  ( Notifications
  , Notification
  , NotificationID(..)
  , NotificationsOptions
  , NotificationRecord
  , NotificationPropsF
  , Action
  , ActionID(..)
  , ActionLabel(..)
  , Urgency(..)
  , notifications
  , popups
  , getOptions
  , setOptions
  , getNotification
  , getPopup
  , fromNotification
  , dismiss
  , close
  , invoke
  , fromAction
  , disconnectNotifications
  ) where

import Prelude

import AGS.Binding (Binding)
import AGS.Service (class BindServiceProp, class ServiceConnect, Service)
import AGS.Widget (EffectFn1)
import Data.DateTime.Instant (Instant, instant)
import Data.Enum (class Enum)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe, fromJust)
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable, toMaybe)
import Data.Show.Generic (genericShow)
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff.Compat (runEffectFn1)
import Effect.Uncurried (EffectFn2)
import GObject
  ( class GObjectSignal
  , HandlerID
  , unsafeConnect
  , unsafeCopyGObjectProps
  )
import Partial.Unsafe (unsafePartial)
import Record as Record
import Record.Studio as RS
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (UndefinedOr, uorToMaybe)

-- *** Notifications

foreign import data Notifications ∷ Service

-- * Signals

instance
  ServiceConnect Notifications "changed" (Effect Unit)
  where
  connectService = connectNotifications "changed"

instance
  ServiceConnect Notifications "dismissed" (EffectFn1 NotificationID Unit)
  where
  connectService = connectNotifications "dismissed"

instance
  ServiceConnect Notifications "notified" (EffectFn1 NotificationID Unit)
  where
  connectService = connectNotifications "notified"

instance
  ServiceConnect Notifications "closed" (EffectFn1 NotificationID Unit)
  where
  connectService = connectNotifications "closed"

foreign import disconnectNotifications
  ∷ HandlerID Notifications → Effect Unit

foreign import connectNotifications
  ∷ ∀ f. String → f → Effect (HandlerID Notifications)

-- * Bindings and props

foreign import notifications ∷ Effect (Array Notification)
foreign import popups ∷ Effect (Array Notification)

instance BindServiceProp Notifications "popups" (Array Notification) where
  bindServiceProp = bindNotifications "popups"

instance BindServiceProp Notifications "notifications" (Array Notification) where
  bindServiceProp = bindNotifications "notifications"

instance BindServiceProp Notifications "doNotDisturb" Boolean where
  bindServiceProp = bindNotifications "dnd"

foreign import bindNotifications ∷ ∀ a. String → Effect (Binding a)

-- * Methods

getOptions ∷ Effect { | NotificationsOptions }
getOptions = getOptionsImpl (RS.keys (Proxy @NotificationsOptions))

setOptions
  ∷ ( { | NotificationsOptions }
      → { | NotificationsOptions }
    )
  → Effect Unit
setOptions f = setOptionsImpl <<< f =<< getOptions

foreign import setOptionsImpl ∷ { | NotificationsOptions } → Effect Unit
foreign import getOptionsImpl ∷ Array String → Effect { | NotificationsOptions }

foreign import clear ∷ Effect Unit

getNotification ∷ NotificationID → Effect (Maybe Notification)
getNotification = map uorToMaybe <<< runEffectFn1 getNotificationImpl

foreign import getNotificationImpl
  ∷ EffectFn1 NotificationID (UndefinedOr Notification)

getPopup ∷ NotificationID → Effect (Maybe Notification)
getPopup = map toMaybe <<< runEffectFn1 getPopupImpl

foreign import getPopupImpl ∷ EffectFn1 NotificationID (Nullable Notification)

-- *** Notification

foreign import data Notification ∷ Type

-- | Convert a Notification to a record.
fromNotification ∷ Notification → NotificationRecord
fromNotification =
  unsafeCopyGObjectProps @(NotificationPropsF UndefinedOr String Number)
    >>> RS.mapRecordKind uorToMaybe
    >>> Record.modify (Proxy @"urgency") unsafeParseUrgency
    >>> Record.modify (Proxy @"time") unsafeToInstant

  where
  unsafeParseUrgency = unsafePartial case _ of
    "low" → Low
    "normal" → Normal
    "critical" → Critical

  unsafeToInstant ms = unsafePartial $ fromJust $ instant $ Milliseconds ms

-- * Signals

instance GObjectSignal "dismissed" Notification (EffectFn1 Notification Unit) where
  connect cb notification = unsafeConnect @"dismissed" cb notification

instance GObjectSignal "closed" Notification (EffectFn1 Notification Unit) where
  connect cb notification = unsafeConnect @"closed" cb notification

instance
  GObjectSignal "invoked" Notification (EffectFn2 Notification ActionID Unit) where
  connect cb notification = unsafeConnect @"invoked" cb notification

-- * Bindings and props

-- * Methods

foreign import dismiss ∷ Notification → Effect Unit
foreign import close ∷ Notification → Effect Unit
foreign import invoke ∷ Notification → Action → Effect Unit

-- *** Other types

newtype NotificationID = NotificationID Int

derive instance Newtype NotificationID _
derive newtype instance Eq NotificationID
derive newtype instance Ord NotificationID
derive newtype instance Show NotificationID

type NotificationRecord =
  { | NotificationPropsF Maybe Urgency Instant }

type NotificationPropsF f u t =
  ( id ∷ NotificationID
  , appName ∷ String
  , appIcon ∷ String
  , summary ∷ String
  , body ∷ String
  , actions ∷ Array Action
  , urgency ∷ u
  , time ∷ t
  , image ∷ f String
  , appEntry ∷ f String
  , actionIcons ∷ f Boolean
  , category ∷ f String
  , resident ∷ f Boolean
  , soundFile ∷ f String
  , soundName ∷ f String
  , suppressSound ∷ f Boolean
  , transient ∷ f Boolean
  , x ∷ f Number
  , y ∷ f Number
  )

type NotificationsOptions =
  ( popupTimeout ∷ Milliseconds
  , forceTimeout ∷ Boolean
  , cacheActions ∷ Boolean
  , clearDelay ∷ Milliseconds
  , dnd ∷ Boolean
  )

foreign import data Action ∷ Type

instance Show Action where
  show action = "(Action " <> show (fromAction action) <> ")"

newtype ActionID = ActionID String
newtype ActionLabel = ActionLabel String

derive instance Newtype ActionID _
derive newtype instance Show ActionID

derive instance Newtype ActionLabel _
derive newtype instance Show ActionLabel

-- I don't think copying the props is necessary here
fromAction ∷ Action → { id ∷ ActionID, label ∷ ActionLabel }
fromAction = unsafeCoerce

data Urgency
  = Low
  | Normal
  | Critical

derive instance Eq Urgency
derive instance Ord Urgency
derive instance Generic Urgency _

instance Show Urgency where
  show = genericShow

instance Bounded Urgency where
  top = Critical
  bottom = Low

instance Enum Urgency where
  succ = genericSucc
  pred = genericPred


module AGS.Service.Notifications
  ( Notifications
  , NotificationsSignals
  , Notification
  , NotificationSignals
  , NotificationID(..)
  , NotificationsOptions
  , NotificationRecord
  , NotificationPropsF
  , NotificationsServiceProps
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
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Time.Duration (Milliseconds(..))
import Data.Variant as V
import Effect (Effect)
import Effect.Aff.Compat (mkEffectFn1, runEffectFn1)
import Effect.Uncurried (EffectFn2, mkEffectFn2)
import GObject (class GObjectSignal, HandlerID, unsafeCopyGObjectProps)
import Partial.Unsafe (unsafePartial)
import Record as Record
import Record.Studio as RS
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (UndefinedOr, uorToMaybe)

-- *** Notifications

foreign import data Notifications ∷ Service

-- * Signals

type NotificationsSignals =
  ( changed ∷ Effect Unit
  , dismissed ∷ EffectFn1 NotificationID Unit
  , notified ∷ EffectFn1 NotificationID Unit
  , closed ∷ EffectFn1 NotificationID Unit
  )

instance
  IsSymbol prop ⇒
  ServiceConnect Notifications prop NotificationsSignals cb
  where
  connectService = connectNotifications (reflectSymbol (Proxy @prop))

foreign import disconnectNotifications
  ∷ HandlerID Notifications → Effect Unit

foreign import connectNotifications
  ∷ ∀ f. String → f → Effect (HandlerID Notifications)

-- * Bindings and props

foreign import notifications ∷ Effect (Array Notification)
foreign import popups ∷ Effect (Array Notification)

type NotificationsServiceProps =
  ( popups ∷ Array Notification
  , notifications ∷ Array Notification
  , dnd ∷ Boolean
  )

instance
  IsSymbol prop ⇒
  BindServiceProp Notifications prop NotificationsServiceProps ty where
  bindServiceProp = bindNotifications (reflectSymbol (Proxy @prop))

foreign import bindNotifications ∷ ∀ a. String → Effect (Binding a)

-- * Methods

getOptions ∷ Effect { | NotificationsOptions }
getOptions = getOptionsImpl (RS.keys (Proxy @NotificationsOptions))

setOptions
  ∷ ({ | NotificationsOptions } → { | NotificationsOptions })
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

type NotificationSignals =
  ( dismissed ∷ Notification → Effect Unit
  , closed ∷ Notification → Effect Unit
  , invoked ∷ Notification → ActionID → Effect Unit
  )

type NotificationSignalsOverrides =
  ( dismissed ∷ EffectFn1 Notification Unit
  , closed ∷ EffectFn1 Notification Unit
  , invoked ∷ EffectFn2 Notification ActionID Unit
  )

instance
  GObjectSignal Notification NotificationSignals NotificationSignalsOverrides where
  overrides = V.over
    { dismissed: mkEffectFn1, closed: mkEffectFn1, invoked: mkEffectFn2 }

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


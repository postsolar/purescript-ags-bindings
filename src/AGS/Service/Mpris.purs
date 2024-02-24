module AGS.Service.Mpris
  ( Mpris
  , MprisSignals
  , MprisServiceProps
  , disconnectMpris
  , players
  , matchPlayer
  , BusName
  , Player
  , PlayerProps
  , PlayerRecord
  , PlayerRecordR
  , MprisMetadata
  , MprisMetadataF
  , fromPlayer
  , playPause
  , play
  , stop
  , next
  , previous
  , shuffle
  , loop
  ) where

import Prelude

import AGS.Binding (class BindProp, Binding)
import AGS.Service (class BindServiceProp, class ServiceConnect, Service)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import GObject (class GObjectSignal, HandlerID, unsafeCopyGObjectProps)
import Record as R
import Record.Studio.MapKind (mapRecordKind)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (UndefinedOr, uorToMaybe)

-- *** Mpris

foreign import data Mpris ∷ Service

foreign import disconnectMpris ∷ HandlerID Mpris → Effect Unit
foreign import connectMpris ∷ ∀ f. String → f → Effect (HandlerID Mpris)

-- * Props and bindings

foreign import bindMpris ∷ ∀ a. String → Effect (Binding a)

type MprisServiceProps =
  ( players ∷ Array Player
  )

instance IsSymbol prop ⇒ BindServiceProp Mpris prop MprisServiceProps ty where
  bindServiceProp = bindMpris (reflectSymbol (Proxy @prop))

-- * Signals

type MprisSignals =
  ( changed ∷ EffectFn1 { players ∷ Array Player } Unit
  , "player-changed" ∷ EffectFn2 { players ∷ Array Player } BusName Unit
  , "player-closed" ∷ EffectFn2 { players ∷ Array Player } BusName Unit
  , "player-added" ∷ EffectFn2 { players ∷ Array Player } BusName Unit
  )

instance
  IsSymbol prop ⇒
  ServiceConnect Mpris prop MprisSignals cb where
  connectService = connectMpris (reflectSymbol (Proxy @prop))

-- * Methods

foreign import players ∷ Effect (Array Player)

-- | Returns `Player` which has given string in its bus name.
matchPlayer ∷ String → Effect (Maybe Player)
matchPlayer = map toMaybe <<< matchPlayerImpl

foreign import matchPlayerImpl ∷ String → Effect (Nullable Player)

-- *** Player

newtype BusName = BusName String

type PlayerRecord = Record PlayerRecordR

type PlayerRecordR =
  ( "bus-name" ∷ String
  , "can-go-next" ∷ Boolean
  , "can-go-prev" ∷ Boolean
  , "can-play" ∷ Boolean
  , "cover-path" ∷ Maybe String
  , entry ∷ String
  , identity ∷ String
  , length ∷ Int
  , "loop-status" ∷ Maybe Boolean
  , metadata ∷ MprisMetadata
  , name ∷ String
  , "play-back-status" ∷ String
  , position ∷ Int
  , "shuffle-status" ∷ Maybe Boolean
  , "track-artists" ∷ Array String
  , "track-cover-url" ∷ String
  , "track-title" ∷ String
  , "track-album" ∷ String
  , trackid ∷ String
  , volume ∷ Int
  )

foreign import data Player ∷ Type

type MprisMetadata = MprisMetadataF Maybe

type MprisMetadataF f =
  { "mpris:trackid" ∷ f String
  , "mpris:length" ∷ f Number
  , "mpris:artUrl" ∷ f String
  , "xesam:album" ∷ f String
  , "xesam:albumArtist" ∷ f String
  , "xesam:artist" ∷ f (Array String)
  , "xesam:asText" ∷ f String
  , "xesam:audioBPM" ∷ f Number
  , "xesam:autoRating" ∷ f Number
  , "xesam:comment" ∷ f (Array String)
  , "xesam:composer" ∷ f (Array String)
  , "xesam:contentCreated" ∷ f String
  , "xesam:discNumber" ∷ f Number
  , "xesam:firstUsed" ∷ f String
  , "xesam:genre" ∷ f (Array String)
  , "xesam:lastUsed" ∷ f String
  , "xesam:lyricist" ∷ f (Array String)
  , "xesam:title" ∷ f String
  , "xesam:trackNumber" ∷ f Number
  , "xesam:url" ∷ f String
  , "xesam:useCount" ∷ f Number
  , "xesam:userRating" ∷ f Number
  }

-- * Props and bindings

-- | Convert a `Player` to a record.
fromPlayer ∷ Player → PlayerRecord
fromPlayer = unsafeCopyGObjectProps @PlayerRecordR
  >>> unsafeCoerce
  >>> R.modify (Proxy @"metadata") fromForeignMetadata
  >>> R.modify (Proxy @"cover-path") uorToMaybe
  >>> R.modify (Proxy @"shuffle-status") toMaybe
  >>> R.modify (Proxy @"loop-status") toMaybe

  where
  fromForeignMetadata ∷ MprisMetadataF UndefinedOr → MprisMetadata
  fromForeignMetadata = mapRecordKind uorToMaybe

type PlayerProps =
  -- the dbus name that starts with org.mpris.MediaPlayer2
  ( "bus-name" ∷ String
  -- stripped from busName like spotify or firefox
  , name ∷ String
  -- name of the player like Spotify or Mozilla Firefox
  , identity ∷ String
  -- .desktop entry without the extension
  , entry ∷ String
  , trackid ∷ String
  , "track-artists" ∷ Array String
  , "track-album" ∷ String
  , "track-title" ∷ String
  , "track-cover-url" ∷ String
  -- path to the cached cover art
  , "cover-path" ∷ String
  -- "Playing" | "Paused" | "Stopped"
  , "play-back-status" ∷ String
  , "can-go-next" ∷ Boolean
  , "can-go-prev" ∷ Boolean
  , "can-play" ∷ Boolean
  -- null if shuffle is unsupported by the player
  , "shuffle-status" ∷ Nullable Boolean
  -- "None" | "Track" | "Playlist" | null if shuffle is unsupported by the player
  , "loop-status" ∷ Nullable String
  , volume ∷ Number
  , length ∷ Number
  , position ∷ Number
  )

instance BindProp Player PlayerProps

-- * Signals

type PlayerSignals =
  ( position ∷ EffectFn2 Player Number Unit
  , closed ∷ EffectFn1 Player Unit
  )

instance GObjectSignal Player PlayerSignals

-- * Methods

playPause ∷ Player → Effect Unit
playPause = unsafeCoerce _.playPause

play ∷ Player → Effect Unit
play = unsafeCoerce _.play

stop ∷ Player → Effect Unit
stop = unsafeCoerce _.stop

next ∷ Player → Effect Unit
next = unsafeCoerce _.next

previous ∷ Player → Effect Unit
previous = unsafeCoerce _.previous

shuffle ∷ Player → Effect Unit
shuffle = unsafeCoerce _.shuffle

loop ∷ Player → Effect Unit
loop = unsafeCoerce _.loop


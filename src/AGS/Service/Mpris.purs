module AGS.Service.Mpris
  ( Mpris
  , disconnectMpris
  , players
  , matchPlayer
  , BusName
  , Player
  , PlayerRecord
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

import AGS.Binding (class BindProp, Binding, unsafeBindProp)
import AGS.Service (class BindServiceProp, class ServiceConnect, Service)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import GObject (class GObjectSignal, HandlerID, unsafeConnect)
import Unsafe.Coerce (unsafeCoerce)

-- *** Mpris

foreign import data Mpris ∷ Service

foreign import disconnectMpris ∷ HandlerID Mpris → Effect Unit
foreign import connectMpris ∷ ∀ f. String → f → Effect (HandlerID Mpris)

-- * Props and bindings

foreign import bindMpris ∷ ∀ a. String → Effect (Binding a)

instance BindServiceProp Mpris "players" (Array Player) where
  bindServiceProp = bindMpris "players"

-- * Signals

instance
  ServiceConnect Mpris
    "changed"
    (EffectFn1 { players ∷ Array Player } Unit) where
  connectService = connectMpris "changed"

instance
  ServiceConnect Mpris
    "player-changed"
    (EffectFn2 { players ∷ Array Player } BusName Unit) where
  connectService = connectMpris "player-changed"

instance
  ServiceConnect Mpris
    "player-closed"
    (EffectFn2 { players ∷ Array Player } BusName Unit) where
  connectService = connectMpris "player-closed"

instance
  ServiceConnect Mpris
    "player-added"
    (EffectFn2 { players ∷ Array Player } BusName Unit) where
  connectService = connectMpris "player-added"

-- * Methods

foreign import players ∷ Effect (Array Player)

matchPlayer ∷ String → Effect (Maybe Player)
matchPlayer = map toMaybe <<< matchPlayerImpl

foreign import matchPlayerImpl ∷ String → Effect (Nullable Player)

-- *** Player

newtype BusName = BusName String

type PlayerRecord =
  { "bus-name" ∷ String
  , "can-go-next" ∷ Boolean
  , "can-go-prev" ∷ Boolean
  , "can-play" ∷ Boolean
  , "cover-path" ∷ String
  , entry ∷ String
  , identity ∷ String
  , length ∷ Int
  , "loop-status" ∷ Nullable Boolean
  , name ∷ String
  , "play-back-status" ∷ String
  , position ∷ Int
  , "shuffle-status" ∷ Nullable Boolean
  , "track-artists" ∷ Array String
  , "track-cover-url" ∷ String
  , "track-title" ∷ String
  , trackid ∷ String
  , volume ∷ Int
  }

foreign import data Player ∷ Type

-- * Props and bindings

-- | Convert a `Player` to a record.
fromPlayer ∷ Player → PlayerRecord
fromPlayer = unsafeCoerce

-- the dbus name that starts with org.mpris.MediaPlayer2
instance BindProp Player "bus-name" String where
  bindProp o = unsafeBindProp @"bus-name" o

-- stripped from busName like spotify or firefox
instance BindProp Player "name" String where
  bindProp o = unsafeBindProp @"name" o

-- name of the player like Spotify or Mozilla Firefox
instance BindProp Player "identity" String where
  bindProp o = unsafeBindProp @"identity" o

-- .desktop entry without the extension
instance BindProp Player "entry" String where
  bindProp o = unsafeBindProp @"entry" o

instance BindProp Player "trackid" String where
  bindProp o = unsafeBindProp @"trackid" o

instance BindProp Player "track-artists" (Array String) where
  bindProp o = unsafeBindProp @"track-artists" o

instance BindProp Player "track-title" String where
  bindProp o = unsafeBindProp @"track-title" o

instance BindProp Player "track-cover-url" String where
  bindProp o = unsafeBindProp @"track-cover-url" o

-- path to the cached cover art
instance BindProp Player "cover-path" String where
  bindProp o = unsafeBindProp @"cover-path" o

-- "Playing" | "Paused" | "Stopped"
instance BindProp Player "play-back-status" String where
  bindProp o = unsafeBindProp @"play-back-status" o

instance BindProp Player "can-go-next" Boolean where
  bindProp o = unsafeBindProp @"can-go-next" o

instance BindProp Player "can-go-prev" Boolean where
  bindProp o = unsafeBindProp @"can-go-prev" o

instance BindProp Player "can-play" Boolean where
  bindProp o = unsafeBindProp @"can-play" o

-- null if shuffle is unsupported by the player
instance BindProp Player "shuffle-status" (Nullable Boolean) where
  bindProp o = unsafeBindProp @"shuffle-status" o

-- "None" | "Track" | "Playlist" | null if shuffle is unsupported by the player
instance BindProp Player "loop-status" (Nullable String) where
  bindProp o = unsafeBindProp @"loop-status" o

instance BindProp Player "volume" Number where
  bindProp o = unsafeBindProp @"volume" o

instance BindProp Player "length" Number where
  bindProp o = unsafeBindProp @"length" o

instance BindProp Player "position" Number where
  bindProp o = unsafeBindProp @"position" o

-- * Signals

instance GObjectSignal "position" Player (EffectFn2 Player Number Unit) where
  connect cb player = unsafeConnect @"position" cb player

instance GObjectSignal "closed" Player (EffectFn1 Player Unit) where
  connect cb player = unsafeConnect @"closed" cb player

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


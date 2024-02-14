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

import AGS.Service (class ServiceConnect, Service)
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

instance
  ServiceConnect Mpris
    "changed"
    (EffectFn1 { players ∷ Array PlayerRecord } Unit) where
  connectService = connectMpris "changed"

instance
  ServiceConnect Mpris
    "player-changed"
    (EffectFn2 { players ∷ Array PlayerRecord } BusName Unit) where
  connectService = connectMpris "player-changed"

instance
  ServiceConnect Mpris
    "player-closed"
    (EffectFn2 { players ∷ Array PlayerRecord } BusName Unit) where
  connectService = connectMpris "player-closed"

instance
  ServiceConnect Mpris
    "player-added"
    (EffectFn2 { players ∷ Array PlayerRecord } BusName Unit) where
  connectService = connectMpris "player-added"

-- * Methods

foreign import players ∷ Effect (Array PlayerRecord)

matchPlayer ∷ String → Effect (Maybe PlayerRecord)
matchPlayer = map toMaybe <<< matchPlayerImpl

foreign import matchPlayerImpl ∷ String → Effect (Nullable PlayerRecord)

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

-- | Convert a `Player` to an immutable record.
foreign import fromPlayer ∷ Player → PlayerRecord

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


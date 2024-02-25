module Gio.FileMonitorEvent where

import Data.Bounded (class Bounded)
import Data.Bounded.Generic (genericBottom, genericTop)
import Data.Enum (class BoundedEnum, class Enum)
import Data.Enum.Generic
  ( genericCardinality
  , genericFromEnum
  , genericPred
  , genericSucc
  , genericToEnum
  )
import Data.Eq (class Eq)
import Data.Generic.Rep (class Generic)
import Data.Ord (class Ord)
import Data.Show (class Show)
import Data.Show.Generic (genericShow)

data GioFileMonitorEvent
  -- A file changed.
  = Changed
  -- A hint that this was probably the last change in a set of changes.
  | ChangesDoneHint
  -- A file was deleted.
  | Deleted
  -- A file was created.
  | Created
  -- A file attribute was changed.
  | AttributeChanged
  -- The file location will soon be unmounted.
  | PreUnmount
  -- The file location was unmounted.
  | Unmounted
  -- The file was moved -- only sent if the (deprecated) Gio.FileMonitorFlags.SEND_MOVED flag is set
  | Moved
  -- The file was renamed within the current directory -- only sent if the Gio.FileMonitorFlags.WATCH_MOVES flag is set. Since: 2.46.
  | Renamed
  -- The file was moved into the monitored directory from another location -- only sent if the Gio.FileMonitorFlags.WATCH_MOVES flag is set. Since: 2.46.
  | MovedIn
  -- The file was moved out of the monitored directory to another location -- only sent if the Gio.FileMonitorFlags.WATCH_MOVES flag is set. Since: 2.46
  | MovedOut

derive instance Generic GioFileMonitorEvent _
derive instance Eq GioFileMonitorEvent
derive instance Ord GioFileMonitorEvent

instance Show GioFileMonitorEvent where
  show = genericShow

instance Bounded GioFileMonitorEvent where
  top = genericTop
  bottom = genericBottom

instance Enum GioFileMonitorEvent where
  succ = genericSucc
  pred = genericPred

instance BoundedEnum GioFileMonitorEvent where
  cardinality = genericCardinality
  toEnum = genericToEnum
  fromEnum = genericFromEnum


module GLib.Priority
  ( Priority
  , defaultIdle
  , default
  , high
  , highIdle
  , low
  ) where

foreign import data Priority ∷ Type

foreign import defaultIdle ∷ Priority
foreign import high ∷ Priority
foreign import highIdle ∷ Priority
foreign import low ∷ Priority

default ∷ Priority
default = default_

foreign import default_ ∷ Priority

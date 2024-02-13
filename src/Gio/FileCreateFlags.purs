module Gio.FileCreateFlags
  ( GioFileCreateFlags
  , none
  , private
  , replaceDestination
  ) where

foreign import data GioFileCreateFlags ∷ Type

foreign import none ∷ GioFileCreateFlags
foreign import replaceDestination ∷ GioFileCreateFlags

private ∷ GioFileCreateFlags
private = private_

foreign import private_ ∷ GioFileCreateFlags

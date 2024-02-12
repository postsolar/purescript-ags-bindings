-- https://lazka.github.io/pgi-docs/Gio-2.0/classes/File.html#class-details

module Gio.File where

foreign import data GioFile ∷ Type

-- | Create a GioFile from a string containing a file path.
-- | https://lazka.github.io/pgi-docs/Gio-2.0/classes/File.html#Gio.File.new_for_path
foreign import fromPath ∷ String → GioFile


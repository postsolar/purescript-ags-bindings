module AGS.Utils.Exec
  ( exec
  , async
  , subprocess
  , module Gio.Subprocess
  ) where

import Prelude

import AGS.Widget (Widget)
import Data.Array.NonEmpty (NonEmptyArray, toArray)
import Effect (Effect)
import Effect.Aff (Aff)
import Gio.Subprocess (Subprocess, forceSubprocessExit) as Gio.Subprocess
import Prim.Row (class Union)
import Promise (Promise)
import Promise.Aff (toAffE)
import Record (modify) as R
import Type.Proxy (Proxy(..))

foreign import exec ∷ String → Effect String

async ∷ NonEmptyArray String → Aff String
async cmd = toAffE (execAsync (toArray cmd))

foreign import execAsync ∷ Array String → Effect (Promise String)

subprocess
  ∷ ∀ r r'
  . Union r r' SubprocessProps
  ⇒ Record (command ∷ NonEmptyArray String | r)
  → Effect Gio.Subprocess.Subprocess
subprocess = subprocessImpl <<< R.modify (Proxy @"command") toArray

type SubprocessProps =
  ( command ∷ NonEmptyArray String
  , callback ∷ String → Effect Unit
  , onError ∷ String → Effect Unit
  , bind ∷ Widget
  )

foreign import subprocessImpl
  ∷ ∀ r. Record r → Effect Gio.Subprocess.Subprocess


{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Books.Module(
    ModuleM
  , Module
  , ModuleName(..)
  , entry
  , hoistModule
  ) where

import Books.Types
import qualified Books.Task as TA

import Data.Monoid
import qualified Data.Map as Map

import Control.Applicative (Applicative)
import Control.Monad.Writer

data Module a = Module (Map.Map Name Value)
  deriving (Eq, Show)

instance Monoid (Module a) where
  mempty  = empty
  mappend = append

newtype ModuleM e a = ModuleM { runModuleM :: Writer (Module e) a }
  deriving (Functor, Applicative, Monad, MonadWriter (Module e))

class ModuleName a where
  name :: Module a -> Name

hoistModule :: ModuleName e => ModuleM e a -> TA.TaskM a
hoistModule m = do
    tell $ TA.singleton (name w) (ValueMap modul)
    return a
  where
    (a, w)       = runWriter $ runModuleM m
    Module modul = w

entry :: Name -> Value -> ModuleM e ()
entry name value = tell (singleton name value)

empty :: Module a
empty = Module Map.empty

append :: Module a -> Module a -> Module a
append (Module m1) (Module m2) = Module (m1 `mappend` m2)

singleton :: Name -> Value -> Module a
singleton name value = Module (Map.singleton name value)

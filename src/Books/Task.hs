{-# LANGUAGE GeneralizedNewtypeDeriving, OverloadedStrings #-}
module Books.Task(
    Task
  , TaskM
  , task
  , sudo
  , ignoreErrors
  , description
  , singleton
  , toByteString
  ) where

import Books.Types

import Data.Monoid
import Data.Yaml.Builder
import qualified Data.Text as T
import qualified Data.Map as Map

import Control.Applicative (Applicative)
import Control.Monad.Writer

newtype Task = Task { asMap :: Map.Map Name Value }
  deriving (Eq, Show)

instance Monoid Task where
  mempty  = empty
  mappend = append

instance ToYaml Task where
  toYaml = mapping . Map.toList . Map.map toYaml . asMap

newtype TaskM a = TaskM { runTaskM :: Writer Task a }
  deriving (Functor, Applicative, Monad, MonadWriter Task)

empty :: Task
empty = Task Map.empty

append :: Task -> Task -> Task
append (Task a) (Task b) = Task (a `mappend` b)

singleton :: Name -> Value -> Task
singleton n v = Task (Map.singleton n v)

task :: Name -> TaskM a -> Task
task name taskm = snd $ runWriter $ runTaskM $ do
  tell $ singleton "name" (ValueText name)
  taskm

sudo :: Bool -> TaskM ()
sudo b = tell $ singleton "sudo" (ValueBool b)

ignoreErrors :: Bool -> TaskM ()
ignoreErrors b = tell $ singleton "ignore_errors" (ValueBool b)

description :: T.Text -> TaskM ()
description desc = tell $ singleton "description" (ValueText desc)

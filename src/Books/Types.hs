{-# LANGUAGE OverloadedStrings #-}
module Books.Types(
    module Books.Types
  , module Data.Monoid
  , module T
  ) where

import Data.List
import Data.Monoid
import Data.Yaml.Builder
import qualified Data.Map as Map
import qualified Data.Text as T

type Name      = T.Text
type TextValue = T.Text

data Value = ValueText TextValue
           | ValueBool Bool
           | ValueMap (Map.Map Name Value)
           deriving (Eq, Ord, Show)

flatten :: Map.Map Name Value -> T.Text
flatten =  T.concat . intersperse " " . map concatTuple . Map.toList
  where
    concatTuple (a, b)       = a <> "=" <> toText b

    toText (ValueText text)  = text
    toText (ValueBool b)     = if b then "yes" else "no"
    toText (ValueMap _ )     = error "no nested maps allowed"

instance ToYaml Value where
  toYaml (ValueText text) = string text
  toYaml (ValueBool bool) = string (if bool then "yes" else "no")
  toYaml (ValueMap m)     = string (flatten m)

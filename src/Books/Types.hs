{-# LANGUAGE OverloadedStrings, FlexibleInstances #-}
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

class ToValue a where
  toValue :: a -> Value

instance ToValue Value where
  toValue = id

instance ToValue T.Text where
  toValue = ValueText

instance ToValue (Map.Map Name Value) where
  toValue = ValueMap

instance ToValue Bool where
  toValue = ValueBool

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

{-# LANGUAGE OverloadedStrings #-}
module Books.Modules.Files.Fetch.Copy where

import Books.Modules.Modules

import Data.Text (pack)

data Copy = Copy

instance ModuleName Copy where
  name = const "copy"

copy :: ModuleM Copy () -> TaskM ()
copy = hoistModule

copySrc :: FilePath -> ModuleM Copy ()
copySrc = entry "src" . pack

copyDest :: FilePath -> ModuleM Copy ()
copyDest = entry "dest" . pack

copyForce :: Bool -> ModuleM Copy ()
copyForce = entry "force"

copyBackup :: Bool -> ModuleM Copy ()
copyBackup = entry "backup"

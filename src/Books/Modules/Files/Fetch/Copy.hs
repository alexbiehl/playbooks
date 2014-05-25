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
copySrc file = entry "src" (ValueText (pack file))

copyDest :: FilePath -> ModuleM Copy ()
copyDest file = entry "dest" (ValueText (pack file))

copyForce :: Bool -> ModuleM Copy ()
copyForce force = entry "force" (ValueBool force)

copyBackup :: Bool -> ModuleM Copy ()
copyBackup backup = entry "backup" (ValueBool backup)

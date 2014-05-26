{-# LANGUAGE OverloadedStrings #-}

module Books.Modules.System.User where

import Books.Modules.Modules

import Data.List (intersperse)
import qualified Data.Text as T

data User = User

instance ModuleName User where
  name = const "user"

user :: Name -> ModuleM User () -> TaskM ()
user name modul = hoistModule modul'
  where
    modul' = do
      entry "name" name
      modul

group :: Name -> ModuleM User ()
group = entry "group"

groups :: [Name] -> ModuleM User ()
groups = entry "groups" . T.concat . intersperse ","

moveHome :: Bool -> ModuleM User ()
moveHome = entry "move_home"

nonUnique :: Bool -> ModuleM User ()
nonUnique = entry "non_unique"

shell :: Name -> ModuleM User ()
shell = entry "shell"

system :: Bool -> ModuleM User ()
system = entry "system"

uid :: Name -> ModuleM User ()
uid = entry "uid"

generateSSHKey :: Bool -> ModuleM User ()
generateSSHKey = entry "generate_ssh_key"

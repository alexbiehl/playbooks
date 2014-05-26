{-# LANGUAGE OverloadedStrings #-}
module Main where

import Books

import qualified Data.ByteString as BS

copyX = task "dasd copy" $ do
  copy $ do
    copySrc "/var/www/.htaccess"
    copyDest "/var/www/.htaccess1"

  description "copies something"
  sudo True
  ignoreErrors True

createCoolBashUser name = task ("creating user " <> name) $ do
  user name $ do
    group "coolpeople"
    shell "bash"
    moveHome True

createUsers = map createCoolBashUser ["Bert", "Blubb"]

main :: IO ()
main = do
  BS.putStrLn $ toByteString (createUsers ++ [copyX])

{-# LANGUAGE OverloadedStrings #-}
module Main where

import Books

import qualified Data.ByteString as BS

copyX = task "dasd copy" $ do
  description "copies something"

  copy $ do
    copySrc "/var/www/.htaccess"
    copyDest "/var/www/.htaccess1"

  sudo True
  ignoreErrors True

copyY = task "...." $ do
  copy $ do
    copySrc "...."
    copyDest "...."

main :: IO ()
main = do
  BS.putStrLn $ toByteString [copyX, copyY]

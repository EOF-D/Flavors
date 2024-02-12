module Main where

import qualified FlavorsServer (serve)

main :: IO ()
main = do
  FlavorsServer.serve

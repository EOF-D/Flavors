{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

module Server.API (main) where

import Data.Aeson (FromJSON, ToJSON, decodeFileStrict, encode, withObject, (.:), (.:?), (.=))
import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Morpheus (interpreter)
import Data.Morpheus.Document (importGQLDocument)
import Data.Morpheus.Types (RootResolver (..), Undefined (..))
import Data.Text (Text)
import GHC.Generics (Generic)

importGQLDocument "assets/schema.gql"

main :: IO ()
main =
  putStrLn "Hello World!"

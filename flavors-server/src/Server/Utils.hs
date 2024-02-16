module Server.Utils
  ( runServer,
  )
where

import Control.Monad.IO.Class (MonadIO (liftIO))
import Server.API (flavorsAPI)
import Web.Scotty (body, post, raw, scotty)

runServer :: IO ()
runServer = scotty 3000 $ do
  post "/api" $ raw =<< (liftIO . flavorsAPI =<< body)

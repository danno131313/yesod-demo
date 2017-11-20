{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
import Yesod

data App = App

mkYesod "App" [parseRoutes|
    /           HomeR GET
    /test/#Int  TestR GET
    |]

instance Yesod App

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    let title = "Test" :: String
    setTitle "Welcome to my Site"
    $(whamletFile "home.hamlet")

getTestR :: Int -> Handler Html
getTestR x = defaultLayout $ do
    $(whamletFile "test.hamlet")

main = warp 3000 App

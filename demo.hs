{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
import Yesod
import Text.Cassius (cassiusFile)

data App = App

mkYesod "App" [parseRoutes|
    /           HomeR GET POST
    /fib/#Int   TestR GET
    |]

instance Yesod App
instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

data IntQuery = IntQuery Int deriving (Show)

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    (formWidget, enctype) <- generateFormPost intForm
    toWidget $(cassiusFile "home.cassius")
    let title = "My first Yesod site" :: String
    setTitle "Welcome to my Site"
    $(whamletFile "home.hamlet")

postHomeR :: Handler Html
postHomeR = defaultLayout $ do
    ((result, formWidget), enctype) <- runFormPost intForm
    case result of
      FormSuccess (IntQuery int) -> redirect $ TestR $ nonNeg int
      _ -> redirect HomeR

nonNeg :: Int -> Int
nonNeg x = case (x < 0) of
             True -> 0
             False -> x

fibs :: [Integer]
fibs = scanl (+) 0 (1:fibs)

intForm = renderDivs $ IntQuery
    <$> areq intField "Value" Nothing

getTestR :: Int -> Handler Html
getTestR x = defaultLayout $ do
    toWidget $(cassiusFile "test.cassius")
    $(whamletFile "test.hamlet")

main = warp 3000 App

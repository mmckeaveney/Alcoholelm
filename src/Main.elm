module Main exposing (..)

import Html exposing (text)
import Model exposing (..)
import Update exposing (..)
import View exposing (appView)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getDrinks )
        , view = appView
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

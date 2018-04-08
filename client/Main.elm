module Main exposing (..)

import Html exposing (program)
import Model exposing (initialModel, Model)
import View exposing (view)
import Update exposing (update)
import Msg exposing (..)
import Receive exposing (subscriptions)


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

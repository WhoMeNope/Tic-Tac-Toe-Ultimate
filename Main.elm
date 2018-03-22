module Main exposing (..)

import Html exposing (program)
import Model exposing (initialModel, Model)
import View exposing (view)
import Update exposing (update, Msg)


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> Sub.none
        , view = view
        }

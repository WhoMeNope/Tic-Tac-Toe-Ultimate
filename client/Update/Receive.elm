module Receive exposing (..)

import WebSocket
import Server exposing (address)
import Msg exposing (..)
import Model exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen address parse


parse : String -> Msg
parse data =
    ReceiveClick 0 0

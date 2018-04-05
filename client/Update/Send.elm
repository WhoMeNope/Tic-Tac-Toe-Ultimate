module Send exposing (..)

import WebSocket
import Server exposing (address)
import Msg exposing (..)


sendClick : Int -> Int -> Cmd Msg
sendClick bindex sindex =
    WebSocket.send address "hello"

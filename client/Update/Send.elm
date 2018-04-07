module Send exposing (..)

import WebSocket
import Json.Encode exposing (encode, object, int)
import Server exposing (address, encodeEvent, Event(..))
import Msg exposing (..)


sendClick : Int -> Int -> Cmd Msg
sendClick bindex sindex =
    let
        encodeClick =
            object
                [ encodeEvent Server.SquareClick
                , ( "Board", int bindex )
                , ( "Square", int sindex )
                ]
    in
        WebSocket.send address (encode 0 encodeClick)

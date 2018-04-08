module Receive exposing (subscriptions)

import WebSocket
import Json.Decode exposing (Decoder, int, decodeString, bool)
import Json.Decode.Pipeline exposing (decode, required)
import Server exposing (address, Event(..), decodeEvent)
import Msg exposing (..)
import Model exposing (Model)
import Player exposing (..)
import Result exposing (withDefault)
import Debug exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen address parse


parse : String -> Msg
parse json =
    let
        event =
            decodeEvent json
    in
        case event of
            Server.SquareClick ->
                parseReceiveClick json

            Server.Connected ->
                parseReceiveConnected json

            UNKNOWN ->
                Msg.ReceiveUnknown


parseReceiveClick : String -> Msg
parseReceiveClick json =
    let
        decoder =
            decode ReceiveClick
                |> required "Board" int
                |> required "Square" int

        event =
            decodeString decoder json
    in
        Result.withDefault Msg.ReceiveUnknown event


parseReceiveConnected : String -> Msg
parseReceiveConnected json =
    let
        receiveConnectedDecoder : Bool -> Bool -> Msg
        receiveConnectedDecoder isX isXfirst =
            let
                player =
                    if isX then
                        X
                    else
                        O

                turn =
                    if isXfirst then
                        X
                    else
                        O
            in
                ReceiveConnected player turn

        decoder =
            decode receiveConnectedDecoder
                |> required "IsX" bool
                |> required "IsXfirst" bool

        event =
            decodeString decoder json
    in
        Result.withDefault Msg.ReceiveUnknown event

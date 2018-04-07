module Server exposing (address, Event(..), encodeEvent, decodeEvent)

import Json.Decode exposing (Value, string, decodeString, field)
import Json.Encode exposing (string)
import Result exposing (toMaybe)


address =
    "ws://localhost:8080"


type Event
    = Connected
    | SquareClick
    | UNKNOWN


encodeEvent : Event -> ( String, Value )
encodeEvent event =
    let
        value =
            case event of
                SquareClick ->
                    "SQUARE_CLICKED"

                _ ->
                    "UNKNOWN"
    in
        ( "Event", Json.Encode.string value )


decodeEvent : String -> Event
decodeEvent json =
    let
        value : Maybe String
        value =
            decodeString (field "Event" Json.Decode.string) json
                |> Result.toMaybe
    in
        case value of
            Just "SQUARE_CLICKED" ->
                SquareClick

            Just "CONNECTED" ->
                Connected

            _ ->
                UNKNOWN

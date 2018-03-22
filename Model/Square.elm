module Square exposing (..)

import Player exposing (Player, playerToString)


type alias Square =
    Maybe Player


squareToString square =
    case square of
        Nothing ->
            ""

        Just player ->
            playerToString player

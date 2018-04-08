module Board exposing (..)

import Player exposing (Player, playerToString)
import Array exposing (..)


type alias Square =
    Maybe Player


type Board
    = Playing (Array Square)
    | Done (Maybe Player)


squareToString : Square -> String
squareToString square =
    case square of
        Nothing ->
            ""

        Just player ->
            playerToString player


emptyBoard : Board
emptyBoard =
    Playing (initialize 9 (always Maybe.Nothing))

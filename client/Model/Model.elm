module Model exposing (..)

import Player exposing (..)
import Board exposing (Board, emptyBoard)
import Array exposing (..)


type alias Model =
    { boards : Array Board
    , turn : Player
    , boardToPlay : Maybe Int
    , game : GameState
    }


initialModel : Model
initialModel =
    { boards = initialize 9 (always emptyBoard)
    , turn = X
    , boardToPlay = Nothing
    , game = Started
    }


type GameState
    = Started
    | Won Player
    | Drawn

module Model exposing (..)

import Player exposing (..)
import Square exposing (..)
import Board exposing (..)
import Array exposing (..)


type alias Model =
    { squares : Array Square
    , turn : Player
    , game : GameState
    }


initialModel : Model
initialModel =
    { squares = emptyBoard
    , turn = X
    , game = Started
    }


type GameState
    = Started
    | Won
    | Drawn

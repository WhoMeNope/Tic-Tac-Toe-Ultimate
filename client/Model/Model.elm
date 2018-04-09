module Model exposing (..)

import Player exposing (..)
import Board exposing (Board, emptyBoard, getGameWinner, isGameFull)
import Array exposing (..)


type alias Model =
    { boards : Array Board
    , turn : Player
    , iam : Player
    , boardToPlay : Maybe Int
    , game : GameState
    }


initialModel : Model
initialModel =
    { boards = initialize 9 (always emptyBoard)
    , turn = X
    , iam = X
    , boardToPlay = Nothing
    , game = Connecting
    }


type GameState
    = Connecting
    | Started
    | Won Player
    | Drawn


checkGameWinner : Model -> GameState
checkGameWinner model =
    let
        winner =
            getGameWinner model.boards

        gameFull =
            isGameFull model.boards
    in
        case winner of
            Nothing ->
                if gameFull then
                    Drawn
                else
                    Started

            Just player ->
                Won player

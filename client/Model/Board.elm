module Board exposing (Square, Board(..), squareToString, emptyBoard, getGameWinner, isBoardFull, getBoardWinner, isGameFull)

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


boardDiagonals =
    [ [ 0, 1, 2 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 0, 4, 8 ]
    , [ 2, 4, 6 ]
    ]


getGameWinner : Array Board -> Maybe Player
getGameWinner boards =
    let
        lineWinner : List Int -> Maybe Player
        lineWinner indList =
            if (allAreSame (List.map (\x -> get x boards) indList)) then
                let
                    index =
                        List.head indList |> Maybe.withDefault -1

                    board =
                        Array.get index boards |> Maybe.withDefault (Done Nothing)
                in
                    case board of
                        Done (Just p) ->
                            Just p

                        _ ->
                            Nothing
            else
                Nothing
    in
        List.head (List.filterMap lineWinner boardDiagonals)


getBoardWinner : Array Square -> Maybe Player
getBoardWinner squares =
    let
        lineWinner : List Int -> Maybe Player
        lineWinner indList =
            if (allAreSame (List.map (\x -> get x squares) indList)) then
                (Maybe.withDefault Nothing (Array.get (Maybe.withDefault -1 (List.head indList)) squares))
            else
                Nothing
    in
        List.head (List.filterMap lineWinner boardDiagonals)


isBoardFull : Array Square -> Bool
isBoardFull squares =
    noNothings squares


isGameFull : Array Board -> Bool
isGameFull boards =
    noPlayings boards



-----------------------------------
-- HELPERS


allAreSame : List a -> Bool
allAreSame xs =
    case xs of
        [] ->
            True

        y :: ys ->
            List.all ((==) y) ys


noPlayings : Array Board -> Bool
noPlayings xs =
    let
        isPlaying v =
            case v of
                Playing _ ->
                    True

                Done _ ->
                    False
    in
        xs |> Array.foldl (::) [] |> List.any isPlaying |> not


noNothings : Array (Maybe a) -> Bool
noNothings xs =
    let
        isNothing v =
            case v of
                Nothing ->
                    True

                Just _ ->
                    False
    in
        xs |> Array.foldl (::) [] |> List.any isNothing |> not

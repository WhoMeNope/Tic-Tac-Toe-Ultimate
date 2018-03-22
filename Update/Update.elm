module Update exposing (..)

import List exposing (..)
import Array exposing (..)
import Model exposing (..)
import Player exposing (..)
import Square exposing (..)


type Msg
    = SquareClick Int
    | Restart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SquareClick index ->
            case Maybe.withDefault Nothing (Array.get index model.squares) of
                Nothing ->
                    squareClick model index

                Just player ->
                    ( model, Cmd.none )

        Restart ->
            ( { initialModel | turn = model.turn |> togglePlayer }, Cmd.none )


getWinner : Array Square -> Maybe Player
getWinner squares =
    let
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

        lineWinner : List Int -> Maybe Player
        lineWinner indList =
            if (allAreSame (List.map (\x -> get x squares) indList)) then
                (Maybe.withDefault Nothing (Array.get (Maybe.withDefault -1 (List.head indList)) squares))
            else
                Nothing
    in
        List.head (List.filterMap lineWinner boardDiagonals)


squareClick : Model -> Int -> ( Model, Cmd Msg )
squareClick model index =
    let
        newSquares =
            case model.game of
                Started ->
                    set index (model.turn |> Just) model.squares

                Won ->
                    model.squares

                Drawn ->
                    model.squares

        winner =
            getWinner newSquares

        boardFilled =
            noNothings newSquares
    in
        case winner of
            Nothing ->
                if boardFilled then
                    ( { model
                        | squares = newSquares
                        , turn = togglePlayer (model.turn)
                      }
                    , Cmd.none
                    )
                else
                    ( { model
                        | squares = newSquares
                        , turn = model.turn
                        , game = Drawn
                      }
                    , Cmd.none
                    )

            Just player ->
                ( { model
                    | squares = newSquares
                    , turn = player
                    , game = Won
                  }
                , Cmd.none
                )


allAreSame : List a -> Bool
allAreSame xs =
    case xs of
        [] ->
            True

        y :: ys ->
            List.all ((==) y) ys


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
        xs |> Array.foldl (::) [] |> List.any isNothing

module Update exposing (..)

import Msg exposing (..)
import List exposing (..)
import Array exposing (..)
import Model exposing (..)
import Player exposing (..)
import Board exposing (Board, Square)
import Send exposing (sendClick)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Restart ->
            ( initialModel, Cmd.none )

        SquareClick bindex sindex ->
            if model.game == Started then
                if model.turn == model.iam then
                    case model.boardToPlay of
                        Nothing ->
                            boardClick model bindex sindex

                        Just b ->
                            if b == bindex then
                                boardClick model bindex sindex
                            else
                                ( model, Cmd.none )
                else
                    ( model, Cmd.none )
            else
                ( model, Cmd.none )

        ReceiveClick bindex sindex ->
            if model.game == Started then
                if model.turn == model.iam then
                    ( model, Cmd.none )
                else
                    case model.boardToPlay of
                        Nothing ->
                            boardClick model bindex sindex

                        Just b ->
                            if b == bindex then
                                boardClick model bindex sindex
                            else
                                ( model, Cmd.none )
            else
                ( model, Cmd.none )

        ReceiveConnected player turn ->
            ( { model | game = Started, iam = player, turn = turn }, Cmd.none )

        ReceiveUnknown ->
            ( model, Cmd.none )


checkGameWinner : Model -> GameState
checkGameWinner model =
    let
        winner =
            getGameWinner model.boards

        gameFull =
            noPlayings model.boards
    in
        case winner of
            Nothing ->
                if gameFull then
                    Drawn
                else
                    Started

            Just player ->
                Won player


boardClick : Model -> Int -> Int -> ( Model, Cmd Msg )
boardClick model bindex sindex =
    let
        board =
            Array.get bindex model.boards

        newboard =
            case board of
                Just board ->
                    Just (squareClick board model.turn sindex)

                Nothing ->
                    Nothing

        newturn =
            if newboard == board then
                model.turn
            else
                togglePlayer model.turn
    in
        case newboard of
            Nothing ->
                ( model, Cmd.none )

            Just newboard ->
                let
                    newmodel =
                        { model | turn = newturn, boards = (Array.set bindex newboard model.boards) }

                    gamestate =
                        checkGameWinner newmodel

                    isBoardFull b =
                        case b of
                            Board.Done _ ->
                                True

                            Board.Playing _ ->
                                False

                    thisBoardFull =
                        isBoardFull newboard

                    nextBoard =
                        (Array.get sindex newmodel.boards) |> Maybe.withDefault (Board.Done Nothing)

                    nextBoardFull =
                        isBoardFull nextBoard

                    toPlayNext =
                        if nextBoardFull then
                            if thisBoardFull then
                                Nothing
                            else
                                Just bindex
                        else
                            Just sindex
                in
                    ( { newmodel | game = gamestate, boardToPlay = toPlayNext }, sendClick bindex sindex )


squareClick : Board -> Player -> Int -> Board
squareClick board player index =
    case board of
        Board.Done _ ->
            board

        Board.Playing squares ->
            if (Maybe.withDefault Nothing (Array.get index squares)) == Nothing then
                let
                    newsquares =
                        Array.set index (Just player) squares

                    winner =
                        getWinner newsquares

                    boardFilled =
                        noNothings newsquares
                in
                    case winner of
                        Nothing ->
                            if boardFilled then
                                Board.Done Nothing
                            else
                                Board.Playing newsquares

                        Just player ->
                            Board.Done (Just player)
            else
                board


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
                        Array.get index boards |> Maybe.withDefault (Board.Done Nothing)
                in
                    case board of
                        Board.Done (Just p) ->
                            Just p

                        _ ->
                            Nothing
            else
                Nothing
    in
        List.head (List.filterMap lineWinner boardDiagonals)


getWinner : Array Square -> Maybe Player
getWinner squares =
    let
        lineWinner : List Int -> Maybe Player
        lineWinner indList =
            if (allAreSame (List.map (\x -> get x squares) indList)) then
                (Maybe.withDefault Nothing (Array.get (Maybe.withDefault -1 (List.head indList)) squares))
            else
                Nothing
    in
        List.head (List.filterMap lineWinner boardDiagonals)


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
                Board.Playing _ ->
                    True

                Board.Done _ ->
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

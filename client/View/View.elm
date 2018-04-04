module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, attribute, src)
import Html.Events exposing (onClick)
import Stylesheet exposing (stylesheet)
import Array exposing (..)
import Model exposing (..)
import Board exposing (Board, Square, squareToString)
import Player exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    main_ []
        [ stylesheet "./assets/core.css"
        , header []
            [ h1 []
                [ text "Tic-Tac-Toe" ]
            , img [ src "./assets/ultimate.svg" ]
                []
            ]
        , viewStatus model.game model.turn
        , viewGame model.boardToPlay model.boards
        , viewControls model.game
        ]


viewGame : Maybe Int -> Array Board -> Html Msg
viewGame toPlay boards =
    div [ class "game" ]
        (Array.toList
            (Array.indexedMap (viewBoard toPlay) boards)
        )


viewBoard : Maybe Int -> Int -> Board -> Html Msg
viewBoard toPlay bindex board =
    let
        viewSquare : Int -> Square -> Html Msg
        viewSquare index square =
            button
                [ class "square", onClick (SquareClick bindex index) ]
                [ square |> squareToString |> text ]
    in
        case board of
            Board.Done player ->
                case player of
                    Nothing ->
                        div [ class "board" ]
                            [ div [ class "winner" ]
                                [ "" |> text ]
                            ]

                    Just player ->
                        div [ class "board" ]
                            [ div [ class "winner" ]
                                [ player |> playerToString |> text ]
                            ]

            Board.Playing squares ->
                let
                    renderedSqs =
                        (Array.toList
                            (Array.indexedMap viewSquare squares)
                        )
                in
                    case toPlay of
                        Just b ->
                            if b == bindex then
                                div [ class "board highlight" ] renderedSqs
                            else
                                div [ class "board" ] renderedSqs

                        Nothing ->
                            div [ class "board" ] renderedSqs


viewControls : GameState -> Html Msg
viewControls game =
    div [ class "footer" ]
        (case game of
            Started ->
                [ text "" ]

            _ ->
                [ button [ id "restart", onClick Restart ]
                    [ text "New game!" ]
                ]
        )


viewStatus : GameState -> Player -> Html Msg
viewStatus game player =
    case game of
        Started ->
            div []
                [ h3
                    [ id "status" ]
                    [ text "Turn: " ]
                , h3
                    [ id "turn" ]
                    [ player |> playerToString |> text ]
                ]

        Won winner ->
            div []
                [ h3
                    [ id "status" ]
                    [ text "Winner: " ]
                , h3
                    [ id "turn" ]
                    [ winner |> playerToString |> text ]
                ]

        Drawn ->
            div []
                [ h3
                    [ id "status" ]
                    [ text "Draw" ]
                , h3
                    [ id "turn" ]
                    [ "" |> text ]
                ]

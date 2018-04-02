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
        [ stylesheet "./core.css"
        , header []
            [ h1 []
                [ text "Tic-Tac-Toe" ]
            , img [ src "./ultimate.svg" ]
                []
            ]
        , viewStatus model.game model.turn
        , viewGame model.boards
        , viewControls model.game
        ]


viewGame : Array Board -> Html Msg
viewGame boards =
    div [ class "game" ]
        (Array.toList
            (Array.indexedMap viewBoard boards)
        )


viewBoard : Int -> Board -> Html Msg
viewBoard bindex board =
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
                div [ class "board" ]
                    (Array.toList
                        (Array.indexedMap viewSquare squares)
                    )


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

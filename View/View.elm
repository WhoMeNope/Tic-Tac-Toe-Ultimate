module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, attribute)
import Html.Events exposing (onClick)
import Stylesheet exposing (stylesheet)
import Array exposing (..)
import Model exposing (..)
import Square exposing (..)
import Player exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    main_ []
        [ stylesheet "./core.css"
        , h1 []
            [ text "Tic-Tac-Toe" ]
        , viewStatus model.game model.turn
        , viewBoard model.squares
        , viewControls model.game

        -- , div [] [ model |> toString |> text ]
        ]


viewBoard : Array Square -> Html Msg
viewBoard squares =
    let
        viewSquare : Int -> Square -> Html Msg
        viewSquare index square =
            button
                [ class "square", onClick (SquareClick index) ]
                [ text (square |> squareToString) ]
    in
        div [ class "board" ]
            (Array.toList
                (Array.indexedMap
                    viewSquare
                    squares
                )
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

        Won ->
            div []
                [ h3
                    [ id "status" ]
                    [ text "Winner: " ]
                , h3
                    [ id "turn" ]
                    [ player |> playerToString |> text ]
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

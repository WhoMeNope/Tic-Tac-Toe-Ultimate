module Player exposing (..)


type Player
    = X
    | O


togglePlayer : Player -> Player
togglePlayer player =
    case player of
        X ->
            O

        O ->
            X


playerToString : Player -> String
playerToString player =
    case player of
        X ->
            "X"

        O ->
            "O"

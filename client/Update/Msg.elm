module Msg exposing (..)

import Player exposing (..)


type Msg
    = SquareClick Int Int
    | Restart
    | ReceiveClick Int Int
    | ReceiveConnected Player Player
    | ReceiveUnknown

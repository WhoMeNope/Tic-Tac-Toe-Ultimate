module Board exposing (..)

import Square exposing (..)
import Array exposing (..)


emptyBoard : Array Square
emptyBoard =
    initialize 9 (always Maybe.Nothing)

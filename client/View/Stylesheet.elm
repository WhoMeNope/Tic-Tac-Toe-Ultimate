module Stylesheet exposing (stylesheet)

import Html exposing (node, Html)
import Html.Attributes exposing (attribute)


stylesheet : String -> Html a
stylesheet path =
    let
        attrs =
            [ attribute "rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" path
            ]
    in
        node "link" attrs []

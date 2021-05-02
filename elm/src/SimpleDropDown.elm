module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)


main =
    Browser.sandbox { init = "", update = update, view = view }


view model =
    div []
        [ select [ on "change" Html.Events.targetValue ]
            [ option [ value "strawberry" ] [ text "strawberry" ]
            , option [ value "chocolate" ] [ text "chocolate" ]
            , option [ value "vanilla" ] [ text "vanilla" ]
            ]
        , div [] [ text (Debug.toString model) ]
        ]


update msg model =
    model ++ Debug.toString msg

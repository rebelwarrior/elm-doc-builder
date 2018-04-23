module HeaderAndFooter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


viewHeader title =
    header []
        [ h1 []
            [ text title ]
        ]


viewFooter =
    footer []
        [  a [ href "https://www.github.com/rebelwarrior" ]
            [ text "coded with 💚 by rebelwarrior" ]
        ]


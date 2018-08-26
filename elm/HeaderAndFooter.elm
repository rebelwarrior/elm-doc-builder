module HeaderAndFooter exposing (..)

import Html exposing (a, footer, h1, header, text)
import Html.Attributes exposing (href)


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


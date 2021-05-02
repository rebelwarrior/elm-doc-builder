module HeaderAndFooter exposing (..)

import Html exposing (a, footer, h1, header, text)
import Html.Attributes exposing (href, attribute)


viewHeader title =
    header []
        [ h1 []
            [ text title ]
        ]


viewFooter =
    footer []
        [  a 
            [ href "https://www.github.com/rebelwarrior" 
            , attribute "aria-label" "David Acevedo's GitHub page."
            ]
            [ text "coded with 💚 by rebelwarrior" ]
        ]


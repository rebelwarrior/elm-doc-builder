module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Json.Encode


main =
    Browser.sandbox { init = "", update = update, view = view }


view model =
    div
            [ class "alert alert-danger alert-dismissible fade show"
            , attribute "role" "alert"
            ]
            [ text
                """
            Alert to Dismiss
            As Kevin Mitnick said in a recent Slashdot interview,
            '. . . security is not a product that can be purchased off the shelf,
            but consists of policies, people, processes, and technology.'
            I believe that security is fundamentally a social concept.
            In practice, you can open your windows and leave the front door locked and
            people won’t just walk in through your window or pick your doorlock,
            even though both are relatively easy tasks.
            Locked doors and open windows work because a locked door is mostly a symbolic measure;
            it forces an intruder to make a conscious act of violation in order to enter a house,
            and that alone is enough to separate criminals from well-doers. -- Bunnie Huang
        """
            , button
                [ class "close"
                , attribute "type" "button"
                , attribute "data-dismiss" "alert"
                , attribute "aria-label" "Close"

                -- , onClick [ onClickAction ]
                ]
                [ span [ attribute "aria-hidden" "true" ] [ text "×" ]
                ]
            ]


update msg model =
    model ++ Debug.toString msg



-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
--     crossorigin="anonymous">
-- <link rel="stylesheet" href="assets/css/animation.css">
-- div [ (Html.Attributes.property "innerHTML" (Json.Encode.string "Test <em>em</em> here.")) ] []


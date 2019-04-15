module AlertBuilder exposing (buildAlerts, buildAlertQuestion)

import CssTranslation exposing (css)
import Html exposing (button, div, span, text)
import Html.Attributes exposing (attribute, class, type_)
import Html.Events exposing (onClick)
import Model


buildAlerts : List String -> Html.Html (List Model.QuestionAction)
buildAlerts messageList =
    viewAlertMsg messageList


buildAlertQuestion : String -> Int -> Html.Html (List Model.QuestionAction)
buildAlertQuestion message questionID =
    -- Need to add options like: warning, info etc.
    displayMessage message (Model.RmQuestion questionID)


viewAlertMsg : List String -> Html.Html (List Model.QuestionAction)
viewAlertMsg messageList =
    messageList
        |> List.map (\msg -> displayMessage msg (Model.ClearAlert msg))
        |> div [ class "alerts" ]


displayMessage : String -> Model.QuestionAction -> Html.Html (List Model.QuestionAction)
displayMessage message onClickAction =
    div
        [ class css.flash
        , attribute "role" "alert" --Possibly switch to "status" for a11y
        , attribute "aria-live" "polite"
        ]
        [ text message
        , button
            [ class css.close
            , attribute "type" "button"
            , attribute "data-dismiss" "alert"
            , attribute "aria-label" "Close"
            , onClick [ onClickAction ]
            ]
            [ span [ attribute "aria-hidden" "true" ] [ text "×" ]
            ]
        ]
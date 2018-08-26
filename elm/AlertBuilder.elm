module AlertBuilder exposing (buildAlerts, viewAlertMsg)

import CssTranslation exposing (css)
import Html exposing (button, div, span, text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import Model


buildAlerts : List String -> Html.Html (List Model.QuestionAction)
buildAlerts messageList =
    viewAlertMsg messageList


viewAlertMsg : List String -> Html.Html (List Model.QuestionAction)
viewAlertMsg messageList =
    let
        displayMessage : String -> Html.Html (List Model.QuestionAction)
        displayMessage message =
            div
                [ class css.flash
                , attribute "role" "alert"
                ]
                [ text message
                , button
                    [ class css.close
                    , attribute "type" "button"
                    , attribute "data-dismiss" "alert"
                    , attribute "aria-label" "Close"
                    , onClick (List.singleton (Model.ClearAlert message))
                    ]
                    [ span [ attribute "aria-hidden" "true" ] [ text "×" ]
                    ]
                ]
    in
    messageList
        |> List.map displayMessage
        |> div [ class "alerts" ]

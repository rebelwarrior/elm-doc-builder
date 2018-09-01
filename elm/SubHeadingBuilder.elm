module SubHeadingBuilder exposing (buildSubHeading)

import Html exposing (..)
import Html.Attributes exposing (class)
import Model


buildSubHeading : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildSubHeading question =
    let
        subheadingFunction : List (Attribute msg) -> List (Html msg) -> Html msg
        subheadingFunction =
            case String.concat question.text of
                "1" ->
                    h1

                "2" ->
                    h2

                "3" ->
                    h3

                "4" ->
                    h4

                "5" ->
                    h5

                "6" ->
                    h6

                _ ->
                    h2
                    
    in
    subheadingFunction [ class "sub-heading" ] [ text question.title ]

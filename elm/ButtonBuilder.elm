module ButtonBuilder exposing (buildButton)

import CssTranslation exposing (css)
import Extra exposing (firstListOfNestedList)
import Html exposing (button, div, text)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onClick)
import Model


buildButton : Model.QuestionRecord -> Html.Html (List Model.QuestionAction)
buildButton question =
    div []
        [ button
            [ class css.button_outline
            , type_ "button" --vs type "submit"
            , onClick (firstListOfNestedList question.actions)
            ]
            [ text question.title ]
        ]

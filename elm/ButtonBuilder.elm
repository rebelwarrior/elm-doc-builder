module ButtonBuilder exposing (buildButton)

-- import CssTranslation exposing (css)
import Extra exposing (firstListOfNestedList)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model


buildButton : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildButton question =
    div []
        [ button
            [ class "btn btn-outline-secondary" --css.button_outline
            , onClick (firstListOfNestedList question.actions)
            ]
            [ text question.title ]
        ]

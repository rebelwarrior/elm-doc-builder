module ButtonBuilder exposing (buildButton)

import CssTranslation exposing (css)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model


buildButton : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildButton record =
    let
        firstOfList : List (List Model.QuestionAction) -> List Model.QuestionAction
        firstOfList list =
            case list of
                hd :: tl -> hd
                []       -> []
    in
    div []
        [ button
            [ class css.button_outline
            , onClick (firstOfList record.actions)
            ]
            [ text record.title ]
        ]

module EditBoxBuilder exposing (buildEditBoxQuestion, buildTextAreaQuestion)

import CssTranslation exposing (css)
import Extra exposing (takeFirstText)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model


buildEditBoxQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildEditBoxQuestion question =
    div [ attribute "data-uuid" (toString question.uuid) ]
        [ div [ class "question-text" ] [ text question.title ]
        , div [ class "question-description" ] [ text (takeFirstText question.text) ]
        , div [ class "edit-box" ]
            [ button
                [ class css.edit_button_class
                , type_ "button"
                , onClick (List.singleton (Model.StartEdit question.uuid))
                ]
                [ text css.edit_button ]
            , div
                [ class "edit-content"
                , style [ ( "border", "thin dashed black" ), ( "padding", "1rem" ) ]
                ]
                (buildContentParrographs question.options)
            ]
        ]

-- this Function Can be extracted to Extra
buildContentParrographs : List String -> List (Html msg)
buildContentParrographs stringList =
    stringList
        |> List.concatMap (String.split "\n")
        |> List.map (\x -> p [] [ text x ])

buildAreaText : List String -> List (Html msg)
buildAreaText stringList =
    stringList 
        |> List.intersperse "\n" 
        |> List.foldr (++) ""
        |> (\s -> [ text s ])


buildTextAreaQuestion : Bool -> Model.QuestionRecord -> Html (List Model.QuestionAction)
buildTextAreaQuestion areaOnly question =
    let
        onInputFn : String -> List Model.QuestionAction 
        onInputFn string = 
            List.singleton (Model.ReplaceAllOptions question.uuid [string])

        boxOrArea : Bool -> Html (List Model.QuestionAction)
        boxOrArea areaOnlyBool =
            if areaOnlyBool then
                div [] []
            else
                button
                    [ class (css.edit_button_class ++ " test")
                    , type_ "button"
                    , onClick (List.singleton (Model.StopEdit question.uuid))
                    ]
                    [ text css.done_button ]
    in
    div [ attribute "data-uuid" (toString question.uuid) ]
        [ div [ class "question-text" ] [ text question.title ]
        , div [ class "question-description" ] [ text (takeFirstText question.text) ]
        , boxOrArea areaOnly
        , div [ class "edit-box" ]
            [ textarea
                [ class css.form_control
                , attribute "rows" "10"
                , style [ ( "border", "1px solid" ), ( "padding", "1rem" ) ]
                , spellcheck True
                , (Html.Events.onInput onInputFn ) -- Triggers when ppl type 
                -- should collapse all the text into one string in the first option and save it in the model.
                ]
                (buildAreaText question.options)
            ]
        ]

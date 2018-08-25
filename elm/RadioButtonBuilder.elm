module RadioButtonBuilder exposing (buildRadioButtonQuestion)

import Array
import CssTranslation exposing (css)
import Extra exposing (takeFirstText)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Json.Decode
import Model


buildRadioButtonQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildRadioButtonQuestion question =
    div [ class css.question ]
        [ div [ class css.radiobuttons, attribute "data-uuid" (String.fromInt question.uuid) ] []
        , div [ class "question-text" ] [ text question.title ]
        , div [ class "question-description" ] [ text (takeFirstText question.text) ]
        , fieldset [ class css.fieldset_inputs ]
            [ legend [ class css.legend ] [ text question.title ]
            , div [ class css.custom_radio ] (listOfRadioButtons question)
            ]
        ]


listOfRadioButtons : Model.QuestionRecord -> List (Html (List Model.QuestionAction))
listOfRadioButtons question =
    let
        -- ## Decoder below:
        actionList : String -> List Model.QuestionAction
        actionList value =
            valueOrder value question.options
                |> List.concatMap (orderToActions question.actions)

        valueToActions : String -> Json.Decode.Decoder (List Model.QuestionAction)
        valueToActions value =
            value
                |> actionList
                |> Json.Decode.succeed

        valueOrder : String -> List String -> List Int
        valueOrder value options =
            options
                |> List.indexedMap Tuple.pair
                |> List.filter (\( i, v ) -> String.startsWith v value)
                |> List.map Tuple.first

        orderToActions : List (List Model.QuestionAction) -> Int -> List Model.QuestionAction
        orderToActions actions int =
            actions
                |> Array.fromList
                |> Array.get int
                |> Maybe.withDefault []

        valueDecoder =
            Html.Events.targetValue
                |> Json.Decode.andThen valueToActions

        -- ## End of Decoder
        radioButton index optionName =
            div [ class css.list_radio ]
                [ input
                    [ type_ "radio"
                    , id optionName
                    , name question.title
                    , value optionName
                    , on "change" valueDecoder -- This is a Json Decoder I need a new one that spits out a QuestionAction
                    ]
                    []
                , label
                    [ for optionName
                    , style  "padding-left" "5px"
                    ]
                    [ text optionName ]
                ]
    in
    question.options
        |> List.indexedMap radioButton

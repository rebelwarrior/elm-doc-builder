module DropDownBuilder exposing (buildDropDownQuestion)

import Array
import CssTranslation exposing (css)
import Extra exposing (takeFirstText) 
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Json.Decode
import Model


buildDropDownQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildDropDownQuestion question =
    let
        -- ## Decoder below:
        valueToActions : String -> Json.Decode.Decoder (List Model.QuestionAction)
        valueToActions value =
            let
                valueOrderList : List Int
                valueOrderList =
                    valueOrder value question.options

                actionList : List Model.QuestionAction
                actionList =
                    valueOrderList
                        |> List.concatMap (orderToActions question.actions)
                        -- orderToActions question.actions (valueOrder v question.options)
            in
                actionList
                    |> Json.Decode.succeed

        valueOrder : String -> List String -> List Int
        valueOrder value options =
            options
                |> List.indexedMap (,)
                |> List.filter (\( i, optionLongName ) -> String.startsWith value optionLongName)
                |> List.map (\( i, _ ) -> i)
                --|> List.head -- should this even return one? maybe should return a list
                --|> Maybe.withDefault 0 -- This can hide an error Should return a Maybe Int


        -- This can be consolidated. -- Maybe I can map this over a list of Ints above
        orderToActions : List (List Model.QuestionAction) -> Int -> List Model.QuestionAction
        orderToActions actions int =
            actions
                |> Array.fromList
                |> Array.get int
                |> Maybe.withDefault []

        valueDecoder =
            Html.Events.targetValue
                |> Json.Decode.andThen valueToActions

        -- End of Decoder
    in
        div [ class css.question ]
            [ Html.label [ class "question-text", attribute "for" question.title ] [ text question.title ]
            , div [ class "question-description" ] [ text (takeFirstText question.text) ]
            , select
                [ class css.select
                , id question.title
                , on "change" valueDecoder
                ]
                (List.indexedMap dropDownOption question.options)
            -- , div [] [text (toString question.actions)] --Debug
            ]


dropDownOption : Int -> String -> Html msg
dropDownOption index optionName =
    let
        abbreviatedName : String
        abbreviatedName =
            optionName
                |> String.trim 
                |> String.left 8

    in
        option
            [ value abbreviatedName
            , id ("data-" ++ abbreviatedName)
            ]
            [ text optionName ]

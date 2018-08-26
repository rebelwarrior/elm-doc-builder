module DropDownBuilder exposing (buildDropDownQuestion)

import Array exposing (fromList, get)
import CssTranslation exposing (css)
import Extra exposing (takeFirstText) 
import Html exposing (..)
import Html.Attributes exposing (attribute, class, id, value)
import Html.Events exposing (on, targetValue)
import Json.Decode
import Model


buildDropDownQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildDropDownQuestion question =
    let
        -- ## Decoder below:
        actionList : String -> List Model.QuestionAction
        actionList value =
            (valueOrder value question.options)
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
                |> List.filter (\( i, optionLongName ) -> String.startsWith value optionLongName)
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
    in
        div [ class css.question ]
            [ label [ class "question-text", attribute "for" question.title ] [ text question.title ]
            , div [ class "question-description" ] [ text (takeFirstText question.text) ]
            , select
                [ class css.select
                , id question.title
                , on "change" valueDecoder
                ]
                (List.indexedMap dropDownOption question.options) -- , div [] [text (toString question.actions)] --Debug
            ]


dropDownOption : Int -> String -> Html msg
dropDownOption index optionName =
    let
        abbreviatedName : String
        abbreviatedName =
            optionName
                |> String.left 10 
                

    in
        option
            [ value abbreviatedName
            , id ("data-" ++ abbreviatedName)
            ]
            [ text optionName ]

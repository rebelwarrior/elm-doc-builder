module RadioButtonBuilder exposing (buildRadioButtonQuestion)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model
import Array
import Html.Events exposing (on, targetValue)
import Json.Decode 
import Extra exposing (takeFirstText)

import CssTranslation exposing (css)


buildRadioButtonQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildRadioButtonQuestion question =
    div [ class css.question ]
    [ div [ class css.radiobuttons, (attribute "data-uuid" (toString question.uuid) ) ] []
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
        valueToActions : String -> Json.Decode.Decoder (List Model.QuestionAction) 
        valueToActions value =
          let 
             actionList v = 
               orderToActions question.actions (valueOrder v question.options)

          in 
            value 
                |> actionList 
                |> Json.Decode.succeed 
    
        valueOrder : String -> List String-> Int 
        valueOrder value options =
            options 
                |> List.indexedMap (,)
                |> List.filter (\ (i, v)  ->  String.startsWith v value )
                |> List.map (\ (i, _) -> i )
                |> List.head
                |> Maybe.withDefault 0 

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

        radioButton index optionName = 
            div [ class css.list_radio ]
                [
                input
                    [ type_ "radio"
                    , id optionName
                    , name question.title  
                    , value optionName
                    , on "change" valueDecoder -- This is a Json Decoder I need a new one that spits out a QuestionAction
                    ] []
                , label [for optionName ] [ text optionName ]
                ]
    in
        question.options 
            |> List.indexedMap radioButton  








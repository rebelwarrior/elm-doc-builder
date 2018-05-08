module DropDownBuilderOld exposing (buildDropDownQuestion)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model
import Html.Events exposing (on, targetValue)
import Json.Decode 
import Array 

import CssTranslation exposing (css)


buildDropDownQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildDropDownQuestion question =
    let
        description : String 
        description = 
            question.text
                |> List.head
                |> Maybe.withDefault ""

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
    
        valueOrder : String -> List String-> List Int 
        valueOrder value options =
            options 
                |> List.indexedMap (,)
                |> List.filter (\ (i, optionLongName)  ->  String.startsWith value optionLongName )
                |> List.map (\ (i, _) -> i )
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


    in
        div [ class css.question ]
            [ Html.label [ class "question-text", attribute "for" question.title ] [ text question.title ]
            , div [ class "question-description" ] [ text description ]
            , select 
                    [ class css.select
                    , id question.title
                    , on "change" valueDecoder  -- This is a Json Decoder I need a new one that spits out a QuestionAction
                    ] (listOptions question.options )
            -- , div [] [text (toString question.actions)] --Debug
            ]

-- TODO change this to the pattern in ... radio buttons?
listOptions : List String -> List (Html msg)
listOptions options =
    options
        |> List.map (\option -> splitToTuple option "|" )
        |> List.map convertTupleToDropDownOption


splitToTuple : String -> String -> ( String , String )
splitToTuple string splitChar =
    let
        listToString :(List String -> List String) -> List String -> String
        listToString function list  =
            list 
            |> function 
            |> List.head
            |> Maybe.withDefault ""

    in
        
        String.split splitChar string
            |> List.take 2
            |> (\x -> (,) (listToString (List.take 1) x) (listToString (List.drop 1) x))


convertTupleToDropDownOption : ( String , String ) -> Html msg
convertTupleToDropDownOption (acronym, name) =
    option [ value acronym
            , id ("data-" ++ acronym) 
            ] 
            [ text name ] 



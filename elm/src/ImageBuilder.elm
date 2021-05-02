module ImageBuilder exposing (buildImage) 

import Html 

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode 

import Model

-- This is an expandable method.
listToTuple : List String -> (String, String)
listToTuple baseList =
    let
        list : List String 
        list = 
            List.take 2 baseList

        firstElement : List String -> String          
        firstElement l = 
            case l of
                f :: _ -> f
                [] -> ""

        last : String         
        last = 
            firstElement (List.reverse list)

        first : String 
        first =
            firstElement list 

    in  
        (first, last)


buildImage : Model.QuestionRecord -> Html msg
buildImage question =
    let
        source = 
            question.text
            |> List.head
            |> Maybe.withDefault ""

        alternate = 
            question.text
            |> List.drop 1
            |> List.head
            |> Maybe.withDefault ""       

        imageStyle =
            question.text
            |> List.drop 2
            |> List.take 1
            |> List.head
            |> Maybe.withDefault ""
            |> Json.Decode.decodeString (Json.Decode.keyValuePairs Json.Decode.string)
            |> Result.withDefault []

            -- |> List.concatMap (String.split ";")
            -- |> List.map (String.split ":")
            -- |> List.map listToTuple

    in       
        img [src source, alt alternate, Html.Attributes.style imageStyle ] []
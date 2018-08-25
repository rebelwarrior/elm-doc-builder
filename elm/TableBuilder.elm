module TableBuilder exposing (..)

{- Uses CSS Grid to give a flexible table.
   Second item on question.text sets columns uses 3 as default
-}

import CssTranslation exposing (css)
import Extra exposing (takeFirstText, takeSecondTextAsInt)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model


buildTable : Model.QuestionRecord -> Html.Html msg
buildTable question =
    let
        title =
            question.title

        description =
            Extra.takeFirstText question.text

        lableText =
            [ "" ]

        placeholderText =
            [ "" ]

        initialState =
            question.options

        columnsNumber =
            Extra.takeSecondTextAsInt question.text |> Result.withDefault 3
    in
    div []
        [ h3 [] [ Html.text question.title ]
        , div [] [ Html.text description ]
        , div
            [ class "container"
            , style (cssGridStyle columnsNumber)
            ]
            (List.indexedMap itemBuilder question.options)
        ]


cssGridStyle : Int -> List ( String, String )
cssGridStyle columns =
    [ ( "display", "grid" )
    , ( "grid-template-columns", String.repeat columns "150px " )
    , ( "background-color", "#eee" )
    , ( "grid-gap", "15px" )
    , ( "margin", "5px" )
    , ( "padding-bottom", "10px" )
    , ( "padding-top", "10px" )
    ]


itemBuilder : Int -> String -> Html.Html msg
itemBuilder i content =
    div [ class ("item--" ++ toString i) ] [ inputBoxBuilder content ]



-- [ Html.text content -- this is where we put the input boxes
-- ]
-- this probablely needs the onInputFn & more than just the content.


inputBoxBuilder : String -> Html.Html msg
inputBoxBuilder content =
    let
        labelText =
            content

        placeholderText =
            content
    in
    Html.form
        [ class "form-inline" ]
        [ label
            [ for labelText
            , class "sr-only"
            ]
            [ Html.text labelText ]
        , input
            [ type_ "text"
            , class "form-control"
            , style [("width", "150px")]
            , id labelText
            , placeholder placeholderText
            ]
            []
        ]



-- Needs function for onInput
-- Not sure I need a form here at all.

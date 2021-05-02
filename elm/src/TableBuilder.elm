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
            Extra.takeSecondTextAsInt question.text
                |> Result.withDefault 3
    in
    -- div []
    Html.form [ class "form-inline" ]
        [ h3 [] [ Html.text question.title ]
        , div [] [ Html.text description ]
        , div
            [ class "container"
            , style "display" "grid"
            , style "grid-template-columns" (String.repeat columnsNumber "150px ")
            , style "background-color" "#eee"
            , style "grid-gap" "15px"
            , style "margin" "5px"
            , style "padding-bottom" "10px"
            , style "padding-top" "10px"
            ]
            (List.indexedMap itemBuilder question.options)
        ]


itemBuilder : Int -> String -> Html.Html msg
itemBuilder i content =
    div
        [ class ("item--" ++ String.fromInt i)
        , title content -- title is tooltip
        ]
        [ inputBoxBuilder content ]



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
    -- Html.form
    --     [ class "form-inline" ]
    div
        []
        [ label
            [ for labelText
            , class "sr-only"
            ]
            [ Html.text labelText ]
        , input
            [ type_ "text"
            , class "form-control table-form css-grid-table"
            , style "width" "-webkit-fill-available"
            , id labelText
            , placeholder placeholderText
            ]
            []
        ]



-- Needs function for onInput
-- Not sure I need a form here at all.
-- style "width" "-webkit-fill-available"
-- style "width" "-moz-available"

module TableBuilder exposing (..)

import CssTranslation exposing (css)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model

-- This should use CSS Grid to give a flexible table. 



buildTable : Model.QuestionRecord -> Html.Html msg
buildTable question =
    div []
        [ div [] [ Html.text question.title ]
        , div
            [ class "container"
            , style cssGridStyle
            ]
            (List.indexedMap itemBuilder question.options) 
        ]


cssGridStyle : List ( String, String )
cssGridStyle =
    [ ( "display", "grid" ) 
    , ("grid-template-columns", "150px 150px 150px")
    ]


itemBuilder : Int -> String -> Html.Html msg
itemBuilder i content =
    div [ class ("item--" ++ toString i) ] [(inputBoxBuilder content)]
        -- [ Html.text content -- this is where we put the input boxes
        -- ]

-- this probablely needs the onInputFn & more than just the content. 
inputBoxBuilder : String -> Html.Html msg 
inputBoxBuilder content =
    let 
        labelText = content
        placeholderText = content 
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
                , id labelText
                , placeholder placeholderText
                ]
                []
            ]

-- Needs function for onInput 
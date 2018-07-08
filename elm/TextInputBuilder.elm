module TextInputBuilder exposing (buildTextInputQuestion)

-- Not Implemented (well)
-- Needs Refactoring

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events as Events exposing (onInput)
import Model
import Extra exposing (takeFirstText)

import CssTranslation exposing (css)


-- Todo Figure out onInputFunction

buildTextInputQuestion : Model.QuestionRecord -> Html msg
buildTextInputQuestion question =
  let
    -- onInputFn string = Model.InputMsg record.uuid string
    placeholderText =
        question.text
          |> List.drop 1
          |> takeFirstText 

  in
    div [ class "question", (attribute "uuid" (toString question.uuid)) ]
        [ div [ class "question-title" ] [ text question.title  ]
        , div [ class "question-description" ] [ text (takeFirstText question.text) ]
        , Html.form [ class css.form ]
            [ input
                [ type_ "text"
                , class css.form  
                , placeholder placeholderText
                -- , autofocus True
                -- , value model.inputText -- what's this?
                -- , (Events.onInput onInputFn )
                ]
                []
            ]
        -- , div [ class "resulting-text" ]
        --      (question.options
        --        |> List.map (\x -> span [] [text (x ++ " ")] )
        --      )
        ]


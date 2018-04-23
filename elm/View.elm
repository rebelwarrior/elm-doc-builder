module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model

import DropDownBuilder exposing (buildDropDownQuestion)
import MarkdownBuilder exposing (buildMarkdown)
import TextInputBuilder exposing (buildTextInputQuestion)
import RadioButtonBuilder exposing (buildRadioButtonQuestion)
import CheckBoxBuilder exposing (buildCheckboxQuestion)
-- import TextInputBuilder exposing (buildTextInputQuestion)
import EditBoxBuilder exposing (buildEditBoxQuestion, buildTextAreaQuestion)
-- import ImageBuilder exposing (buildImage)
import AlertBuilder exposing (buildAlerts)
import CssTranslation exposing (css)

view : Model.Model -> Html (List Model.QuestionAction)
view model =
      div [class css.grid]
      [ buildAlerts model.alertMessages
      , viewH1
      , div [ class css.subgrid ] 
                [ div [ class css.large_column ]
                    (viewQuestionList model.questionList model.questionsInPage)
                , div [] []
                ]
      , viewFooter
      ]



viewH1 : Html msg
viewH1 =
  div [class css.header]
      [ h1 []
        [ a [href "#/"
            , style [ ("color", "inherit"), ("text-decoration", "inherit") ]
            ] [text "Elm Document Builder"] -- Title can be later set w/ a pages object
        ]
      ]

viewFooter : Html msg
viewFooter =
    footer []
        [ a [ href "https://www.github.com/rebelwarrior" ]
            [ text "coded with 💚 by rebelwarrior" ]
        ]

-- This allows proper sorting of the questions.
-- Write a blog about this. 
viewQuestionList : List Model.QuestionRecord -> List Int -> List (Html (List Model.QuestionAction))
viewQuestionList allQuestions questions =
  let
    partialQuestions =
      allQuestions
        |> List.filter (\q -> List.member q.uuid questions)

  in
      questions
        |> List.map (\i -> (List.filter (\q -> q.uuid == i ) partialQuestions))
        |> List.concat
        |> List.map viewQuestionItem


viewQuestionItem : Model.QuestionRecord -> Html (List Model.QuestionAction)
viewQuestionItem questionRecord =
    case questionRecord.questionType of
        Model.DropDown ->
            buildDropDownQuestion questionRecord

        Model.Markdown ->
            buildMarkdown questionRecord

        Model.CheckBox ->
            buildCheckboxQuestion questionRecord

        Model.EditBox ->
            buildEditBoxQuestion questionRecord

        Model.TextBox ->
            buildTextAreaQuestion False questionRecord

        -- Model.TextArea ->
        --     buildTextAreaQuestion True questionRecord

        Model.RadioButton ->
            buildRadioButtonQuestion questionRecord

        -- Model.TextInput ->
        --     buildTextInputQuestion questionRecord

        -- Model.Button ->
        --     buildButton questionRecord

        Model.SubHeading ->
            h2 [ class "sub-heading" ] [ text questionRecord.title ]
            -- This should be called Heading and options should allow you to set the H level 1-6.

        -- Model.NotAQuestion ->
        --     div []
        --         [ div [] [ text "" ]
        --         , div [] [ text "" ]
        --         ]

        -- Model.Image ->
        --     buildImage questionRecord 

        _ ->
            div [] [ text "No QuestionType Error" ]

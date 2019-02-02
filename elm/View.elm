module View exposing (view)

-- import TextInputBuilder exposing (buildTextInputQuestion)

import AlertBuilder exposing (buildAlertQuestion, buildAlerts)
import ButtonBuilder exposing (buildButton)
import CheckBoxBuilder exposing (buildCheckboxQuestion)
import CssTranslation exposing (css)
import DropDownBuilder exposing (buildDropDownQuestion)
import EditBoxBuilder exposing (buildContentParrographs, buildEditBoxQuestion, buildTextAreaQuestion)
import Html exposing (..)
import Html.Attributes exposing (..)
import MarkdownBuilder exposing (buildMarkdown)
import Model
import RadioButtonBuilder exposing (buildRadioButtonQuestion)
import SubHeadingBuilder exposing (buildSubHeading)
import TableBuilder exposing (buildTable)


view : Model.Model -> Html (List Model.QuestionAction)
view model =
    div [ class css.grid ]
        [ buildAlerts model.alertMessages
        , viewH1
        , div [ class css.subgrid ]
            [ div [ class css.large_column ]
                (viewQuestionList model.questionList model.questionsInPage model.buildDoc)
            , div [] []
            ]
        , viewFooter
        ]


viewH1 : Html msg
viewH1 =
    div [ class css.header ]
        [ h1 [] [] ]



-- [ a
--     [ href "#/"
--     , style [ ( "color", "inherit" ), ( "text-decoration", "inherit" ) ]
--     ]
--     [ text "Elm Document Builder" ]
-- -- Title can be later set w/ a pages object
-- ]


viewFooter : Html msg
viewFooter =
    footer []
        [ a [ href "https://www.github.com/rebelwarrior" ]
            [ text "Elm Document Builder coded with 💚 by rebelwarrior" ]
        ]


viewQuestionList : List Model.QuestionRecord -> List Int -> Bool -> List (Html (List Model.QuestionAction))
viewQuestionList allQuestions questions buildDocBool =
    -- This allows proper sorting of the questions.
    -- Avoided doing a filterMap with a case of to get the quesiotn 
    -- due to wanting to display multiple questions with the same number.
    -- Avoided using Dict because it's slower!
    let
        partialQuestions : List Model.QuestionRecord
        partialQuestions =
            allQuestions
                |> List.filter (\q -> List.member q.uuid questions)


    in
    questions
        |> List.map (\i -> List.filter (\q -> q.uuid == i) partialQuestions)
        |> List.concat
        |> List.map (viewQuestionItemFunction buildDocBool)


viewQuestionItemFunction : Bool -> Model.QuestionRecord -> Html (List Model.QuestionAction)
viewQuestionItemFunction buildDoc =
    case buildDoc of
        False ->
            viewQuestionItem

        True ->
            viewSaveQuestion


viewQuestionItem : Model.QuestionRecord -> Html (List Model.QuestionAction)
viewQuestionItem question =
    case question.questionType of
        Model.DropDown ->
            buildDropDownQuestion question

        Model.Markdown ->
            buildMarkdown question

        Model.CheckBox ->
            buildCheckboxQuestion question

        Model.EditBox ->
            buildEditBoxQuestion question

        Model.TextBox ->
            buildTextAreaQuestion False question

        Model.TextArea ->
            -- should this be True?
            buildTextAreaQuestion True question

        Model.RadioButton ->
            buildRadioButtonQuestion question

        -- Model.TextInput ->
        --     buildTextInputQuestion question
        Model.Table ->
            buildTable question

        Model.Button ->
            buildButton question

        Model.SubHeading ->
            buildSubHeading question

        Model.SimpleText ->
            div [] [ text (String.concat question.text) ]

        -- Model.Image ->
        --     buildImage question
        _ ->
            -- This would work better if I could use Action AddAlert
            buildAlertQuestion "Error: Unable to understand QuestionType." question.uuid


viewSaveQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
viewSaveQuestion question =
    case question.saveAction of
        Model.NoSave ->
            div [] []

        Model.SaveAll ->
            viewQuestionItem question

        Model.SaveText ->
            div []
                [ h4 [] [ text question.title ]
                , div [] (buildContentParrographs question.options)
                ]

        _ ->
            div [] []

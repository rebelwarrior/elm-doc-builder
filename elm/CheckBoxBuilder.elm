module CheckBoxBuilder exposing (buildCheckboxQuestion)

import Array exposing (fromList, get)
import CssTranslation exposing (css)
import Html exposing (div, input, label, li, text, ul)
import Html.Attributes exposing (attribute, class, id, type_)
import Html.Events exposing (onCheck)
import Model


-- I *do* need two sets of actions one for on click and one for off click.
-- But I don't need to check this I just need to assume I have these many.
-- I just assume I have two of each (pairs). In order.
-- So option 2 starts at 3 and 4 is the check off
-- This function is in case you want to use an action to append or drop elements from the
-- Quesiton Text Items List (Allowing you to list options checked below for example.)


listQuestionTextItems : List String -> List (Html.Html msg)
listQuestionTextItems questionText =
    let
        listItem string =
            li [] [ text string ]
    in
    questionText
        |> List.map listItem



-- This Function is the Same Across Multiple Question Consider Wrapping.
-- However it also uses Array... and Model


orderToActions : List (List Model.QuestionAction) -> Int -> List Model.QuestionAction
orderToActions actions int =
    actions
        |> Array.fromList
        |> Array.get int
        |> Maybe.withDefault []



-- Should this have an error msg? AlertMsg?
-- This Function is also the Same Across Multiple Questions Consider Wrapping.
-- For wrapping this function should return a Maybe Int have the default set where it's called.


optionNameToOrdinal : String -> List String -> Maybe Int
optionNameToOrdinal optionName options =
    options
        |> List.indexedMap Tuple.pair
        |> List.filter (\( i, v ) -> String.startsWith v optionName)
        |> List.map (\( i, _ ) -> i)
        |> List.head



-- |> Maybe.withDefault 0
-- This Function is also the Same Across Multiple Questions Consider Wrapping.
-- Can be used in Dropdown/Select to generate ID as well.


appendNumberToBeginningOfString : String -> Maybe Int -> String
appendNumberToBeginningOfString string maybeInt =
    let
        beginningOfString =
            -- String.toLower (String.left 8 (String.trim string))
            string
                |> String.trim
                |> String.left 8
                |> String.toLower
    in
    case maybeInt of
        Nothing ->
            beginningOfString

        Just i ->
            beginningOfString ++ String.fromInt i



-- Had to change the output
buildCheckboxQuestion : Model.QuestionRecord -> Html.Html (List Model.QuestionAction)
buildCheckboxQuestion question =
    let
        description : String
        description =
            question.text
                |> List.head
                |> Maybe.withDefault ""
    in
    div [ class "question" ]
        [ div [ class "checkbox-question", attribute "data-uuid" (String.fromInt question.uuid) ] []
        , div [ class "question-text" ] [ text question.title ]
        , div [ class "question-description" ] [ text description ]
        , div [ class css.form_check ]
            [ ul [ class css.unstiled_list ] (listOfCheckBoxes question)
            ]
        , ul [] (listQuestionTextItems (List.drop 1 question.text))
        ]


listOfCheckBoxes : Model.QuestionRecord -> List (Html.Html (List Model.QuestionAction))
listOfCheckBoxes question =
    let
        --The bottom two functions can be extracted if the top on is on a let block for the second
        --and question is added as an argument
        orderToTwoActions : Int -> List Model.QuestionAction
        orderToTwoActions num =
            [ num, num + 1 ]
                |> List.concatMap (orderToActions question.actions)
                |> List.take 2

        optionNameToTwoActions : String -> List Model.QuestionAction
        optionNameToTwoActions optionName =
            optionNameToOrdinal optionName question.options
                |> Maybe.withDefault 0
                -- Multiply resulting number by 2!!
                |> (*) 2
                -- Options in a check box are doubled so multiplying gets us the right number.
                |> orderToTwoActions

        onCheckFn : String -> Bool -> List Model.QuestionAction
        onCheckFn optionName boolChecked =
            if boolChecked then
                -- add something here to mark the option numbered
                optionNameToTwoActions optionName
                    |> List.take 1
            else
                optionNameToTwoActions optionName
                    |> List.drop 1

        checkBoxItem : String -> Html.Html (List Model.QuestionAction)
        checkBoxItem optionName =
            let
                -- requires question.options pure.
                ordinal : Maybe Int
                ordinal =
                    optionNameToOrdinal optionName question.options

                idOfCheck : String
                idOfCheck =
                    appendNumberToBeginningOfString optionName ordinal
            in
            li [ class "checkbox" ]
                [ input
                    [ type_ "checkbox"
                    , id idOfCheck
                    , onCheck (onCheckFn optionName)
                    , class css.form_check_input
                    ]
                    []
                , label [ class css.form_check_label, attribute "for" idOfCheck ] [ text optionName ]
                ]
    in
    question.options
        |> List.map checkBoxItem

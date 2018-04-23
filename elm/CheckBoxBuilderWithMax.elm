module CheckBoxBuilder exposing (buildCheckboxQuestion)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck)
import Model
import CssTranslation exposing (css)
import Array 

-- I *do* need two sets of actions one for on click and one for off click. 
-- But I don't need to check this I just need to assume I have these many. 
-- I just assume I have two of each (pairs). In order.
-- So option 2 starts at 3 and 4 is the check off

-- This function is in case you want to use an action to apped or drop elements from the
-- Quesiton Text Items List (Allowing you to list options checked below for example.)
listQuestionTextItems : List String -> List (Html msg) 
listQuestionTextItems questionText = 
  let 
    listItem string =
      li [] [text string] 
  in 
    questionText
        |> List.map listItem

-- This Function is the Same Across Multiple Question Consider Wrapping. 
orderToActions : List (List Model.QuestionAction) -> Int -> List Model.QuestionAction 
orderToActions actions int =
    actions
        |> Array.fromList 
        |> Array.get int
        |> Maybe.withDefault [] -- Should this have an error msg? AlertMsg? 

-- This Function is also the Same Across Multiple Questions Consider Wrapping. 
-- For wrapping this funciton should return a Maybe Int have the default set where it's called. 
optionNameToOrdinal : String -> List (String) -> Maybe Int 
optionNameToOrdinal optionName options =
    options 
        |> List.indexedMap (,)
        |> List.filter (\ (i, v)  ->  String.startsWith v optionName )
        |> List.map (\ (i, _) -> i )
        |> List.head
        -- |> Maybe.withDefault 0 

addChecked : Maybe Int -> Int -> List Model.QuestionAction -> List Model.QuestionAction 
addChecked ordinal qID list =
    case ordinal of 
        Nothing      -> list  
        Just number  -> (Model.AddChecked number qID) :: list
        -- Define AddChecked number in update, shoot this needs the question id!

removeChecked : Maybe Int -> Int -> List Model.QuestionAction -> List Model.QuestionAction 
removeChecked ordinal qID list =
    case ordinal of 
        Nothing      -> list  
        Just number  -> (Model.RemoveChecked number qID) :: list 
        -- Define RemoveChecked number in update, shoot this needs the question id!
        -- Default Options should be a List Maybe Ints so if the first element is Nothing Max is all.


-- Had to change the output 
buildCheckboxQuestion : Model.QuestionRecord -> Html (List Model.QuestionAction)
buildCheckboxQuestion question =
    let 
        description : String 
        description = 
            question.text
                |> List.head
                |> Maybe.withDefault ""

    in 
        div [ class "question" ]
            [ div [ class "checkbox-question", (attribute "data-uuid" (toString question.uuid)) ] []
            , div [ class "question-text" ] [ text question.title ]
            , div [ class "question-description" ] [ text description ]
            , div [class css.form_check]
                [ ul [ class css.unstiled_list ] (listOfCheckBoxes question)
                ]
            , ul [] (listQuestionTextItems (List.drop 1 question.text))
            ]

listOfCheckBoxes : Model.QuestionRecord ->List (Html (List Model.QuestionAction))
listOfCheckBoxes question = 
   let 
        --The bottom two functions can be extracted if the top on is on a let block for the second
        --and question is added as an argument 
        orderToTwoActions : Int -> List Model.QuestionAction 
        orderToTwoActions num = 
            [num, (num + 1 )]
                |> List.concatMap (orderToActions question.actions)
                |> List.take 2 

        optionNameToTwoActions : String -> Maybe Int -> List Model.QuestionAction 
        optionNameToTwoActions optionName ordinal =
            ordinal
                |> Maybe.withDefault 0  -- Multiply resulting number by 2!!
                |> (*) 2 -- Options in a check box are doubled so multiplying gets us the right number.
                |> orderToTwoActions 

        onCheckFn : String -> Maybe Int -> Bool -> List Model.QuestionAction 
        onCheckFn optionName ordinal boolChecked =
            if boolChecked then -- add something here to mark the option numbered 
                -- add action to add number to default options  
                ordinal
                    |> optionNameToTwoActions optionName
                    |> List.take 1
                    |> addChecked ordinal question.uuid
            else
                -- add action to drop number to default options
                ordinal  
                    |> optionNameToTwoActions optionName
                    |> List.drop 1
                    |> removeChecked ordinal question.uuid

        listChecked : List Int 
        listChecked = 
            question.defaultOptions -- maybe drop 1 or 2 for extra options?
                |> List.foldl maybeNumToNum []

        maybeNumToNum : List Maybe Int -> List Int -> List Int 
        maybeNumToNum  maybeNum accList = 
            case maybeNum of 
                Nothing  -> accList 
                Just num -> num :: accList 

        isChecked : List Int -> Int -> Bool
        isChecked listChecked ordinalInt = 
            List.member ordinalInt listChecked 

        checkBoxItem : List Int -> Int -> String -> Html (List Model.QuestionAction) 
        checkBoxItem listChecked ordinalInt optionName =
            let  
                ordinal : Maybe Int -- requires question.options pure. 
                ordinal = optionNameToOrdinal optionName question.options

                idOfCheck : String 
                idOfCheck = 
                    optionName 
                    |> String.trim 
                    |> String.left 8
                    |> String.toLower
                    |> (\s -> s ++ (toString (Maybe.withDefault 0 ordinal)))
            in 
                li [ class "checkbox" ]
                    [ input
                        [ type_ "checkbox"
                        , id idOfCheck 
                        , onCheck (onCheckFn optionName ordinal) -- is there a way to draw a box as checked already?
                        , class css.form_check_input
                        , checked isChecked -- based on the bool also set the onCheckFn 
                        -- add value "checked" if ordinalInt in checked?
                        -- see https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/checkbox
                        ]
                        []
                    , label [class css.form_check_label, attribute "for" idOfCheck] [ text optionName ]
                    -- , div [] [text (toString (onCheckFn optionName True ))] -- for debuging 
                    -- , div [] [text (toString (onCheckFn optionName False ))] 
                    ]
   in 
        question.options
            |> List.indexedMap (checkBoxItem listChecked)



-- add Model.Max Int String the string being the Alert Msg. 
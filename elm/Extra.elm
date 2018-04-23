module Extra exposing (..)


-- Decided against the below function because it requires Array and Model this 
-- file should have no external dependencies. 

-- From CheckboxBuilder:
-- This Function is the Same Across Multiple Question Consider Wrapping. 
-- However it also uses Array... and Model
-- orderToActions : List (List Model.QuestionAction) -> Int -> List Model.QuestionAction 
-- orderToActions actions int =
--     actions
--         |> Array.fromList 
--         |> Array.get int
--         |> Maybe.withDefault [] -- Should this have an error msg? AlertMsg? 

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

-- This Function is also the Same Across Multiple Questions Consider Wrapping.
-- Can be used in Dropdown/Select to generate ID as well. 
appendNumberToBeginningOfString : String -> Maybe a -> String 
appendNumberToBeginningOfString string maybeA =
    let  
        beginningOfString = -- String.toLower (String.left 8 (String.trim string))
            string 
                |> String.trim 
                |> String.left 8
                |> String.toLower 
    in 
        case maybeA of 
            Nothing -> beginningOfString
            Just a  -> beginningOfString ++ (toString a) 

-- usefull for getting the descriptions of questions.
takeFirstText : List String -> String
takeFirstText listOfStrings =
    listOfStrings
        |> List.head
        |> Maybe.withDefault "" 

-- From Dropdown
valueOrder : String -> List String-> List Int 
valueOrder value options =
    options 
        |> List.indexedMap (,)
        |> List.filter (\ (i, optionLongName)  ->  String.startsWith value optionLongName )
        |> List.map (\ (i, _) -> i )
        --|> List.head -- should this even return one? maybe should return a list
        --|> Maybe.withDefault 0 -- This can hide an error Should return a Maybe Int 
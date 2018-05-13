module Extra exposing (..)

-- For Taking the Description of Questions
takeFirstText : List String -> String
takeFirstText listOfStrings =
    listOfStrings
        |> List.head
        |> Maybe.withDefault "" 

-- useful for getting first Option from Option List
firstListOfNestedList : List (List a) -> List a
firstListOfNestedList list =
    case list of
        hd :: tl -> hd
        []       -> []

-- optionNameToOrdinal : String -> List (String) -> Maybe Int 
-- optionNameToOrdinal optionName options =
--     options 
--         |> List.indexedMap (,)
--         |> List.filter (\ (i, v)  ->  String.startsWith v optionName )
--         |> List.map Tuple.first
--         |> List.head

-- Can be used in Dropdown/Select to generate ID as well. 
-- Is this being used anywhere?
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




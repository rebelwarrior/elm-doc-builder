module Extra exposing (..)

-- useful for getting first Option from Option List
firstListOfNestedList : List (List a) -> List a
firstListOfNestedList list =
    case list of
        hd :: tl -> hd
        []       -> []


optionNameToOrdinal : String -> List (String) -> Maybe Int 
optionNameToOrdinal optionName options =
    options 
        |> List.indexedMap (,)
        |> List.filter (\ (i, v)  ->  String.startsWith v optionName )
        |> List.map (\ (i, _) -> i )
        |> List.head

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
module Extra exposing (..)



{- For Taking the Description of Questions -}
takeFirstText : List String -> String
takeFirstText listOfStrings =
    listOfStrings
        |> List.head
        |> Maybe.withDefault ""



{- For Taking the  of Questions -}
takeSecondTextAsInt : List String -> Result.Result String Int
takeSecondTextAsInt listOfStrings =
    listOfStrings
        |> List.drop 1
        |> List.head
        |> Maybe.withDefault ""
        |> String.toInt
        |> Result.fromMaybe "UnableToCovert to Integer"



{- useful for getting first Option from Option List -}
firstListOfNestedList : List (List a) -> List a
firstListOfNestedList list =
    case list of
        hd :: tl ->
            hd

        [] ->
            []



{- Can be used to append numbers to selections. -}
appendNumberToBeginningOfString : String -> Int -> Maybe String -> String
appendNumberToBeginningOfString string charsLimit maybeString =
    let
        beginningOfString =
            -- String.toLower (String.left 8 (String.trim string))
            string
                |> String.trim
                |> String.left charsLimit
                |> String.toLower
    in
    case maybeString of
        Nothing ->
            beginningOfString

        Just a ->
            beginningOfString ++ a

module Main exposing (..)

import Browser
import Model
import Update
import View


import JsonImporter exposing (decodeImportQuestionInPage, decodeImportQuestionsJson)


type alias Flag =
    { l : String
    , q : String
    }



-- Beginner Program does not load json from _data
-- Also change index.html
-- {-
main : Program () Model.Model (List Model.QuestionAction)
main =
    Browser.sandbox
        { init = Model.model
        , update = Update.update
        , view = View.view
        }
-- -}


{- 
main : Program Flag Model.Model (List Model.QuestionAction)
main =
    Browser.element
        { init = processFlags
        , view = View.view
        , update = Update.updateWithFlags
        , subscriptions = subscriptions
        }
-- -}

subscriptions : Model.Model -> Sub msg
subscriptions model =
    Sub.none



processFlags : Flag -> ( Model.Model, Cmd msg )
processFlags flag =
    let
        listOfQuestionsOnPageResult : Result String (List Int)
        listOfQuestionsOnPageResult =
            decodeImportQuestionInPage flag.l

        listOfQuestionsResult : Result String (List Model.QuestionRecord)
        listOfQuestionsResult =
            decodeImportQuestionsJson flag.q

        captureError : Result String a -> List String
        captureError result =
            case result of
                Ok _    -> []
                Err msg -> List.singleton msg

        initialAlerts : List String
        initialAlerts =
            List.concat [ captureError listOfQuestionsResult, captureError listOfQuestionsOnPageResult ]

        initialQuestionsList : List Model.QuestionRecord
        initialQuestionsList =
            Result.withDefault [] listOfQuestionsResult

        initialQuestionsInPage : List Int
        initialQuestionsInPage =
            Result.withDefault [] listOfQuestionsOnPageResult

        initialBuildDocStatus : Bool
        initialBuildDocStatus =
            False

        initialModel : Model.Model
        initialModel =
            Model.Model initialAlerts initialBuildDocStatus initialQuestionsInPage initialQuestionsList
    in
    ( initialModel, Cmd.none )

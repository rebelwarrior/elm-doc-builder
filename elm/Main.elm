module Main exposing (..)

import Html exposing (..)

import Model
import Update
import View
import JsonImporter exposing (importQuestionInPage, importQuestionsJson)


type alias Flag =
    { l : String
    , q : String
    }


-- Beginner Program does not load json from _data
-- Also change index.html
main : Program Never Model.Model (List Model.QuestionAction)
main =
    Html.beginnerProgram
        { model = Model.model
        , view = View.view
        , update = Update.update
        }

-- main : Program Flag Model.Model (List Model.QuestionAction)
-- main =
--     Html.programWithFlags
--         { init = processFlags
--         , update = Update.updateWithFlags
--         -- , model = Model.model
--         , subscriptions = subscriptions
--         , view = View.view
--         }


subscriptions : Model.Model -> Sub msg
subscriptions model =
    Sub.none


processFlags : Flag -> ( Model.Model, Cmd msg )
processFlags flag =
    let
        listOfQuestionsOnPageResult : Result String (List Int)
        listOfQuestionsOnPageResult =
            importQuestionInPage flag.l

        listOfQuestionsResult : Result String (List Model.QuestionRecord)
        listOfQuestionsResult =
            importQuestionsJson flag.q

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

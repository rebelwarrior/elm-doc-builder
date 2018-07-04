module JsonExporter exposing (..)

import Json.Encode
import Model

exportModel : Model.Model -> String 
exportModel model =
    let     
        questionList = 
            model.questionList 
            |> List.map questionObject 

    in 
        Json.Encode.encode 0 (Json.Encode.list questionList)




-- type alias QuestionRecord =
--     { uuid : Int
--     , title : String
--     , text : List String
--     , questionType : QuestionType
--     , saveAction : SaveAction
--     , options : List String
--     , actions : List (List QuestionAction)
--     , childQuestions : List Int
--     -- , defaultOptions : List Int  --because there maybe more than just one -- Not Implemented
--     -- maybe this should be List Maybe Int
--     }

questionObject : Model.QuestionRecord -> Json.Encode.Value 
questionObject question =
    Json.Encode.object
        [ ( "uuid", Json.Encode.int question.uuid )
        , ( "title", Json.Encode.string question.title )
        , ( "type", Json.Encode.string (toString question.questionType) )
        , ( "options", Json.Encode.string (toString question.options) )
        ]

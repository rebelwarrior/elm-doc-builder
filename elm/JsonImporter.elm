module JsonImporter exposing (..)


import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model


importQuestionsJson : String -> Result String (List Model.QuestionRecord)
importQuestionsJson jsonString =
  decodeString decodeListOfQuestions jsonString

importQuestionInPage : String -> Result String (List Int)
importQuestionInPage jsonString =
  decodeString (list int) jsonString

decodeListOfQuestions : Json.Decode.Decoder (List Model.QuestionRecord)
decodeListOfQuestions =
   list decodeQuestion 

decodeAction : Json.Decode.Decoder Model.QuestionAction  
decodeAction = 
  let 
    toQuestionAction : String -> Int -> Int -> String -> List String -> Json.Decode.Decoder Model.QuestionAction
    toQuestionAction action number belowNumber msg listOptions =
      case (String.toLower action) of 
          "addquestion"      -> succeed (Model.AddQuestion number)
          "removequestion"   -> succeed (Model.RmQuestion number)
          "addquestionbelow" -> succeed (Model.AddQuestionBelow number belowNumber) 
          "replacealloptions"-> succeed (Model.ReplaceAllOptions number listOptions)
          _                  -> fail ("Unable to decode action: " ++ action)

  in 
    decode toQuestionAction 
      |> required "action" string 
      |> optional "number" int 0
      |> optional "below" int 0 
      |> optional "message" string ""
      |> optional "options" (list string) []
      |> resolve 

questionTypeDecoder : String -> Json.Decode.Decoder Model.QuestionType 
questionTypeDecoder string =
    case (String.toLower string) of
      "checkbox"      -> succeed Model.CheckBox
      "radio"         -> succeed Model.RadioButton
      "dropdown"      -> succeed Model.DropDown
      "markdown"      -> succeed Model.Markdown 
      "editbox"       -> succeed Model.EditBox
      "textbox"       -> succeed Model.TextBox
      "textinput"     -> succeed Model.TextInput
      "textarea"      -> succeed Model.TextArea
      "table"         -> succeed Model.Table
      "button"        -> succeed Model.Button
      "subheading"    -> succeed Model.SubHeading
      "notaquestion"  -> succeed Model.NotAQuestion
      _               -> fail ("Value " ++ string ++ "Is not a question type.") -- Should this be Model.Error?


decodeQuestion : Decoder Model.QuestionRecord 
decodeQuestion =
  decode Model.QuestionRecord
    |> required "uid" int
    |> required "title" string 
    |> optional "text" (list string) []
    |> required "type"  (andThen questionTypeDecoder string)
    |> optional "saveAction" (andThen decodeSaveAction string) Model.None
    |> optional "options" (list string) []
    |> optional "actions" (list (list (decodeAction))) [] 
    |> optional "childQuestions" (list int) []


decodeSaveAction : String -> Decoder Model.SaveAction
decodeSaveAction string =
    case (String.toLower string) of 
    "savetext" -> succeed Model.SaveText
    _          -> succeed Model.None


sampleQuestionJson : String
sampleQuestionJson =
  """
    { "uid" : 1001
    , "title" : "Sample Title"
    , "type" : "dropdown"
    , "saveAction" : ""
    , "options" : 
        [ "American"
        , "Gambino"
        ]
    , "actions" : 
      [ 
        [
          { "action" : "AddQuestion"
          , "number" : 1002
          } 
          , 
          { "action" : "RemoveQuestion"
          , "number" : 1003
          }
        ]
        , 
        [
          { "action" : "RemoveQuestion"
          , "number" : 1002
          }
          , 
          { "action" : "AddQuestion"
          , "number" : 1003
          }
        ] 
      ]
    , "childQuestions" : []
    }
  """

module JsonImporter exposing (decodeImportQuestionInPage, decodeImportQuestionsJson) 


import Json.Decode as D
import Json.Decode.Pipeline exposing (..)
import Model

{-
   Don't run Elm Format on this this file.
   Readability is impacted. 
-}

decodeImportQuestionsJson : String -> Result String (List Model.QuestionRecord)
decodeImportQuestionsJson jsonString =
  let
    result : Result D.Error (List Model.QuestionRecord)
    result = D.decodeString decodeListOfQuestions jsonString
  in 
    case result of 
      Err m -> Err (D.errorToString m) 
      Ok  r -> Ok r

decodeImportQuestionInPage : String -> Result String (List Int)
decodeImportQuestionInPage jsonString =
  let 
    result : Result D.Error (List Int)
    result = D.decodeString (D.list D.int) jsonString
  in 
    case result of 
      Err m -> Err (D.errorToString m) 
      Ok  r -> Ok r 

decodeListOfQuestions : D.Decoder (List Model.QuestionRecord)
decodeListOfQuestions =
   D.list questionDecoder 

decodeAction : D.Decoder Model.QuestionAction  
decodeAction = 
  let 
    toQuestionAction : String -> Int -> Int -> String -> List String -> D.Decoder Model.QuestionAction
    toQuestionAction action number belowNumber msg listOptions =
      case (String.toLower action) of 
          "addquestion"      -> D.succeed (Model.AddQuestion number)
          "removequestion"   -> D.succeed (Model.RmQuestion number)
          "addquestionbelow" -> D.succeed (Model.AddQuestionBelow number belowNumber) 
          "replacealloptions"-> D.succeed (Model.ReplaceAllOptions number listOptions)
          "print"            -> D.succeed (Model.Print)
          _                  -> D.fail ("Unable to decode action: " ++ action)

  in 
    D.succeed toQuestionAction
      |> required "action"  D.string 
      |> optional "number"  D.int 0
      |> optional "below"   D.int 0 
      |> optional "message" D.string ""
      |> optional "options" (D.list D.string) []
      |> resolve 

questionTypeDecoder : String -> D.Decoder Model.QuestionType 
questionTypeDecoder string =
  case (String.toLower string) of
    "checkbox"      -> D.succeed Model.CheckBox
    "radio"         -> D.succeed Model.RadioButton
    "dropdown"      -> D.succeed Model.DropDown
    "markdown"      -> D.succeed Model.Markdown 
    "editbox"       -> D.succeed Model.EditBox
    "textbox"       -> D.fail ("Textbox can't imported, you may want editbox.")
    "textinput"     -> D.succeed Model.TextInput
    "textarea"      -> D.succeed Model.TextArea
    "table"         -> D.succeed Model.Table
    "button"        -> D.succeed Model.Button
    "subheading"    -> D.succeed Model.SubHeading
    "simpletext"  -> D.succeed Model.SimpleText
    _               -> D.fail ("Unable to decode question type: " ++ string)


questionDecoder : D.Decoder Model.QuestionRecord 
questionDecoder =
  D.succeed Model.QuestionRecord
    |> required "uid"   D.int
    |> required "title" D.string 
    |> optional "text" (D.list D.string) []
    |> required "type" (D.andThen questionTypeDecoder D.string)
    |> optional "saveAction" (D.andThen decodeSaveAction D.string) Model.None
    |> optional "options" (D.list D.string) []
    |> optional "actions" (D.list (D.list (decodeAction))) [] 
    |> optional "childQuestions" (D.list D.int) []


decodeSaveAction : String -> D.Decoder Model.SaveAction
decodeSaveAction string =
  case (String.toLower string) of 
    "savetext" -> D.succeed Model.SaveText
    "saveall"  -> D.succeed Model.SaveAll
    "none"     -> D.succeed Model.None
    ""         -> D.succeed Model.None
    _          -> D.fail ("Unable to decode save action: " ++ string)

{- 
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
-}
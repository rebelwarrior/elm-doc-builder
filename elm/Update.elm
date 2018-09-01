module Update exposing (update, updateWithFlags)

import Model


pullChildrenQuestions : Int -> Model.Model -> List Int 
pullChildrenQuestions qID model =
  model.questionList 
    |> List.filter (\q -> q.uuid == qID )
    |> List.concatMap .childQuestions


insertIntoListAfter : Int -> Int ->  List Int -> List Int 
insertIntoListAfter number afterNumber fullList = 
  let 
    insertIntoListAfterR : Int -> Int ->  List Int -> List Int -> List Int 
    insertIntoListAfterR num afterNum newList list = 
      case list of
        h :: t ->
            if h == afterNum then 
              insertIntoListAfterR num afterNum (afterNum :: (num :: newList)) t
            else 
              insertIntoListAfterR num afterNum (h :: newList) t
        [] -> 
            newList 
  in 
    insertIntoListAfterR number afterNumber [] fullList 

updateWithAction : Model.QuestionAction -> Model.Model -> Model.Model 
updateWithAction msg model =
    case msg of 
      Model.NoAction -> model 
      Model.AddQuestion qID ->
          { model | questionsInPage = 
                model.questionsInPage
                  |> List.reverse 
                  |> (::) qID 
                  |> List.reverse 
          }
      Model.AddQuestionBelow qID belowQuestionID -> 
          { model | questionsInPage = 
                model.questionsInPage
                  |> List.reverse 
                  |> insertIntoListAfter qID belowQuestionID
          }
      Model.RmQuestion qID ->  
        let 
          childrenQuestions : List Int 
          childrenQuestions = -- Not recursive. 
              pullChildrenQuestions qID model 
                |> (::) qID
        in
          { model | questionsInPage =
            model.questionsInPage
              -- |> List.filter (\i -> i /= qID ) --How to filter a list w/ another list? for children quesitons --use `List.member
              |> List.filter (\i -> not (List.member i childrenQuestions)) 
          }
      Model.AddAlert alertMsg -> 
        { model | alertMessages =  
          alertMsg :: model.alertMessages
        }
      Model.ClearAlert alertMsg -> 
        { model | alertMessages =
          model.alertMessages
            |> List.filter (\s -> s /= alertMsg)
        }
      Model.StartEdit qID -> 
        { model | questionList =
            model.questionList 
              |> List.map (\q -> 
                if q.uuid == qID then 
                  {q | questionType = Model.TextBox } 
                else q)
        }
      Model.StopEdit qID -> 
        { model | questionList =
            model.questionList 
              |> List.map (\q -> 
                if q.uuid == qID then 
                  {q | questionType = Model.EditBox } 
                else q)
        }
      Model.ReplaceAllOptions qID optionsList -> 
        { model | questionList =
            model.questionList 
              |> List.map (\q -> 
                if q.uuid == qID then 
                  {q | options = optionsList } 
                else q)
        }
      Model.Print -> 
        { model | buildDoc = 
          not model.buildDoc
        }
      _ -> 
        { model | alertMessages =  
          model.alertMessages
          |> (::) ("Unable to Process Action, Unknown Acction Type." )  
        }
        

update : List Model.QuestionAction -> Model.Model -> Model.Model 
update msgs model =
    let 
      updateModel : Model.QuestionAction -> Model.Model -> Model.Model
      updateModel message m =
        updateWithAction message m
    in 
      -- This function will apply actions successively to the model 
      msgs
        |> List.foldl (\msg m -> updateModel msg m) model


updateWithFlags : List Model.QuestionAction -> Model.Model -> (Model.Model, Cmd (List Model.QuestionAction))
updateWithFlags msgs model = 
    ((update msgs model), Cmd.none) 


{-
##  Old Method:
    Model.AddQuestion qID position ->
      {model | pages =
        ( model.pages |> List.map
          (\p ->
            if p.pageNumber == model.currentPage then
              { p | questionsInPage =
                p.questionsInPage
                  |> splitAt position
                  |> List.intersperse (Array.fromList [qID])
                  |> List.foldl Array.append Array.empty
              }
            else
              p
          )
        )
-}


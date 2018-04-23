import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)


main =
  beginnerProgram { model = "", view = view, update = update }


view model =
  div [] 
    [ select [ on "change" Html.Events.targetValue ] 
      [ option [value "strawberry" ] [ text "strawberry" ]
      , option [value "chocolate" ] [ text "chocolate" ]
      , option [value "vanilla" ] [ text "vanilla" ]
      ]
    , div [] [ text (toString model) ]
    ]
  

update msg model =
  model ++ (toString msg)

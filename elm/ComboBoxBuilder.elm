module ComboBoxBuilder exposing (buildComboBoxQuestion)

import Array
import CssTranslation exposing (css)
import Extra exposing (takeFirstText) 
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Json.Decode
import Model

buildComboBoxQuestion = 
 []

 {- 
 like a dropdown but you can type the options and drop down shrinks with options
 -}
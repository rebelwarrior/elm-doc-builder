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
   TODO:
   Recreate this: https://jqueryui.com/autocomplete/
   like a dropdown but you can type the options and drop down shrinks with options
   use OnInput to filter list underneath it.
   the list elements should have an onClick funciton that selects the item.
-}

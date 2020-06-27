module ConstantBuilder exposing (..)

{-
Uses title 
Uses new data 
Uses new currency (integer for placing decimal place when converting to string.)
-}

import Html exposing (..)
import Html.Attributes exposing (..)

buildConstant question =
    let 
        num = 
            String.fromInt question.data.integer
            |> formatDecimal question.data.decimalPlaces
        
    in 
    div [] 
    [ div [] [text question.title] 
    , div [] [text num ]
    ]

formatDecimal : Int -> String -> String 
formatDecimal decimalPlaces stringNum  =
    let 
        decimals = 
            String.right decimalPlaces stringNum 
        
        num = 
            String.dropRight decimalPlaces stringNum 

    in 
    case decimals of 
        "" -> num 
        _  -> num ++ "." ++ decimals 
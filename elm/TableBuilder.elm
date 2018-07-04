module TableBuilder exposing (..)

-- This should reaquire TextInput, and just call that a number of times. 

-- Not implemented

import Html
import Html.Attributes

import CssTranslation exposing (css)


type alias TableRecord =
    { qID : Int
    , qType : Table
    , qOpts : QuestionOptions
    , qTitle : String
    , qAttr : List ( String, String )
    }

-- TODO: This should be a collecting question type that ties 6 other text inputs 
-- Essentially a presentation group, maybe use child questions for this?

-- Maybe this should use CSS Grid instead. 

-- update : Msg -> Model -> Model


tableBuilder : QuestionRecord -> Html msg
tableBuilder record =
    let
        title =
            record.qTitle

        opts =
            record.qOpts
    in
        div []
            [ div [] [ text "Additional" ]
            , Html.form []
                [ table []
                    [ thead []
                        [ tr []
                            [ td [] [ text "STR" ]
                            , td [] [ text "DEX" ]
                            , td [] [ text "CON" ]
                            , td [] [ text "INT" ]
                            , td [] [ text "WIS" ]
                            , td [] [ text "CHA" ]
                            ]
                        ]
                    , tbody []
                        [ tr []
                            [ td []
                                [ input [ type_ "text", placeholder "Strength" ] []
                                ]
                            , td []
                                [ input [ type_ "text", placeholder "Dexterity" ] []
                                ]
                            , td []
                                [ input [ type_ "text", placeholder "Constitution" ] []
                                ]
                            , td []
                                [ input [ type_ "text", placeholder "Inteligence" ] []
                                ]
                            , td []
                                [ input [ type_ "text", placeholder "Wisdom" ] []
                                ]
                            , td []
                                [ input [ type_ "text", placeholder "Charisma" ] []
                                ]
                            ]
                        ]
                    ]
                ]
            , button [ class css.button_outline ] [ text "save" ]
            , button [ class css.button_outline ] [ text "Cancel" ]
            ]

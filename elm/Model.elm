module Model exposing (..)


type QuestionType
    = DropDown
    | Markdown 
    | CheckBox
    | RadioButton
    | EditBox
    | TextBox
    | TextArea
    | Button
    | Table
    | SubHeading
    | TextInput -- Rename 
    | Image
    | NotAQuestion -- Rename
    | ErrorType

type alias QuestionRecord =
    { uuid : Int
    , title : String
    , text : List String 
    , questionType : QuestionType
    , saveAction : SaveAction
    , options : List String
    , actions : List (List QuestionAction)
    , childQuestions : List Int 
    -- , defaultOptions : List Int  --because there maybe more than just one -- Not Implemented
    -- maybe this should be List Maybe Int 
    } 

type alias Page =
    Int

type QuestionAction
    = AddQuestion Int -- Add PageNum but for now one page add to the bottom
    | AddQuestionBelow Int Int 
    | RmQuestion Int 
    | StartEdit Int -- internal only called by Edit box
    | StopEdit Int -- internal only called by Edit box
    | ReplaceAllOptions Int (List String) -- used internally by EditBox but open to external
    | AddAlert String 
    | ClearAlert String 
    | Print -- Finishing action to print
    | NoAction 


type SaveAction 
    = SaveText
    | NoSave
    | None 

type alias Model =
    { alertMessages : List String -- Should be Maybe List String or just List String
    , questionsInPage : List Int 
    , questionList : List QuestionRecord
    }


model : Model
model = initialModel

initialModel : Model
initialModel = 
  { alertMessages = [ "Error: bad robot", "Error: Really Bad Robot"]
  , questionsInPage = [110, 100, 1001, 1002, 301]  -- this will have to be expanded w/ the concept of pages later
  , questionList =
    [ --QuestionRecord 1001 "TextInput Q" ["go on living", "iZombie ok", "fine"] TextInput None [] [] []
    --, QuestionRecord 1002 "EditBox" [] EditBox NoSave ["This \n are \n monsters."] [] []
     QuestionRecord 100 "Choose your Class" ["Choose from the follwing list:"] DropDown None [
        "NONE|Please select one:", "RNGR|Ranger", "FTR|Fighter", "THF|Thief"
        ] [ [ RmQuestion 101, RmQuestion 102, RmQuestion 103, RmQuestion 104, RmQuestion 106, RmQuestion 108, RmQuestion 201, RmQuestion 202, RmQuestion 203 ]
          , [ AddQuestion 102, AddQuestion 101, RmQuestion 106, RmQuestion 108, RmQuestion 103, RmQuestion 104, AddQuestion 201, RmQuestion 202, RmQuestion 203 ]
          , [ AddQuestion 106, AddQuestion 103, RmQuestion 102, RmQuestion 108, RmQuestion 101, RmQuestion 104, AddQuestion 202, RmQuestion 201, RmQuestion 203 ]
          , [ AddQuestion 108, AddQuestion 104, RmQuestion 106, RmQuestion 102, RmQuestion 101, RmQuestion 103, AddQuestion 203, RmQuestion 201, RmQuestion 202 ]
          ] [] 
    , QuestionRecord 101 "The Ranger" [ "__Ranger__", rangerMarkdownText] Markdown None [] [] [] 
    , QuestionRecord 102 "" ["_ranger image from devianart_", rangerMarkdownImage] Markdown None [] [] [] 
    , QuestionRecord 103 "The Fighter" [ ("__Fighter__" ++ fighterMarkdownText )] Markdown None [] [] [] 
    , QuestionRecord 106 "" ["_fighter image from devianart_", fighterMarkdownImage] Markdown None [] [] [] 
    , QuestionRecord 104 "The Thief" [ ("__Thief__" ++ thiefMarkdownText )] Markdown None [] [] [] 
    , QuestionRecord 108 "" ["_thief image from devianart_", thiefMarkdownImage] Markdown None [] [] []
    -- Races
    , QuestionRecord 201 "Choose your Race" ["", "Races for Ranger"] RadioButton None ["Elf", "Human"] [[NoAction],[NoAction], [NoAction]] [] 
    , QuestionRecord 202 "Choose your Race" ["", "Races for Fighter"] RadioButton None ["Dwarf","Elf", "Human","Halfling" ] [[NoAction],[NoAction], [NoAction]] [] 
    , QuestionRecord 203 "Choose your Race" ["", "Races for Thief"] RadioButton None ["Human", "Halfling"] [[NoAction],[NoAction], [NoAction]] [] 
    -- Equimpents 
    , QuestionRecord 301 "Starting Gear" ["for the Ranger"] CheckBox None [
        "banana1"
        , "milkshake1", "float1"
        ] [] [] 
    , QuestionRecord 302 "Starting Gear" ["for the Fighter, choose your armament:"] CheckBox None [
        "Chainmail (1 armor, worn, 1 weight) and Adventuring Gear (5 uses, 1 weight)"
        , "Scale Armor (2 armor, worn, clumsy, 3 weight)"
        ] [] [] 
    , QuestionRecord 303 "Starting Gear" ["for the Theif, choose your weapon: (choose two)"] CheckBox None [
        "Dagger (hand, 1 weight), and Short Sword (close, 1 weight)"
        , "Rapier (close, precise, 1 weight)"
        , "Ragged Bow (near, 2 weight) and Bundle Of Arrows (3 ammo, 1 weight)"
        , "3 Throwing Daggers (thrown, near, 0 weight)"
        ] [] [] 
    , QuestionRecord 110 "EditBox test" ["desc for EditBox", "placeholder :) for Text Input should be in options"] EditBox None ["Stuff that Goes Inside.", "new P"] [] [] 
    , QuestionRecord 113 "Radio" ["desc"] RadioButton None ["banana", "milkshake", "float"] [[AddQuestion 102],[NoAction], [RmQuestion 102]] [] 
    , QuestionRecord 114 "Check" ["desc"] CheckBox None ["banana1", "milkshake1", "float1"] [[AddQuestion 102],[RmQuestion 102]] [] 
    ]

  }
  
type alias AnswersRecord =
  { questionID : Int
  , text : String -- Or this could be an HTML section!
  }

questionDescription : QuestionRecord -> String 
questionDescription record =
    record.text 
      |> List.take 1
      |> List.head
      |> Maybe.withDefault "" 


-- For whatever reason this string will not get interpolated into Markdown unless it's concatenated with another imidiately valid markdown block.
rangerMarkdownImage : String 
rangerMarkdownImage =
    """
    ![ranger](https://pre00.deviantart.net/4227/th/pre/i/2014/139/0/6/ranger_by_greyhues-d7ixb51.jpg)
    <style> img{text-align: left; max-width:  400px; max-height: 350px; float: right;} </style>
    """

bardMarkdownImage : String 
bardMarkdownImage =
    """
    ![bard](https://pre00.deviantart.net/cc2b/th/pre/i/2015/292/7/1/minstrel_by_sagasketchbook-d9dngos.jpg)
    <style> img{text-align: left; max-width:  400px; max-height: 350px; float: right;} </style>
    """

thiefMarkdownImage : String 
thiefMarkdownImage =
    """
    ![thief](https://pre00.deviantart.net/cf38/th/pre/f/2014/182/a/3/blackguard_by_i_guyjin_i-d7otvub.jpg)
    <style> img{text-align: left; max-width:  400px; max-height: 350px; float: right;} </style>
    """
--https://pre00.deviantart.net/cf38/th/pre/f/2014/182/a/3/blackguard_by_i_guyjin_i-d7otvub.jpg
--https://orig00.deviantart.net/c7c6/f/2013/301/2/1/once_a_thief_by_isbjorg-d6s41f8.jpg

fighterMarkdownImage : String
fighterMarkdownImage =
    """
    ![fighter](https://pre00.deviantart.net/d6b9/th/pre/f/2011/272/7/2/branwen_the_deathdancer_by_grb76-d4b78yr.jpg)
    <style> img{text-align: left; max-width:  400px; max-height: 350px; float: right;} </style>
    """

fighterMarkdownText : String
fighterMarkdownText = 
    """
    Warriors, soldiers, and the famed defenders of the realm while many know how to fight the _fighter_ class is a true warrior, trained, honed, capable. Many fighters in the Seven Kingdoms don't do it as a full-time, many are farmers, builders, craftmen but all have the strength to protect civilization.
    _"The spit and blood fill your mouth, dirt bites your eyes and yet, one simply does not give up." - King Rodus of Alaria_

    """

rangerMarkdownText : String
rangerMarkdownText =
    """
    The trackers, scouts and hunters of the Seven Kingdoms, they can mostly be found on the fringes of civilization or in-between places. They have a connection with the land, few in civilized places do. 
    _"Hear me. Never flee from a Ranger. Better to face them in battle immediately than to have them hunt you down..."  - Stalwart Warrior_
    """

thiefMarkdownText : String
thiefMarkdownText =
    """
    Quiet as as ghosts they prowl, maybe working for a living is not for them, maybe it is proving their worth, or maybe this is all they know how to do. Why toil in life when so many good things are just ripe for the taking?
    Caravans full of riches travel your land; maybe they should pay a toll for that, and why not you to collect it?
    _"All adventures are thieves... just some are honest about it." – Pathfinder_

    """

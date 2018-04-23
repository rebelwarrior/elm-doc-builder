module InitialModel exposing (initialModel)


initialModel : Model
initialModel =
    { pages =
        [ PageRecord 0 "** Page One **" (Array.fromList [ 108, 109, 101, 111, 110, 106, 103, 104, 102, 107 ])
        , PageRecord 1 "** Page Two **" (Array.fromList [ 102 ])
        ]
    , currentPage = 0
    , alertMessage = Nothing --Just "Test Alert: ooops!"
    , answers =
        [ AnswerRecord 101 [ "Initial Content" ]
        , AnswerRecord 102 [ "nothing" ]
        ]
    , questions =
        [ QuestionRecord 101 "First Checkbox" "what do you want?" CheckBox
            (QuestionOptions [ "one burger", "two cheese", "three pickles" ] [ 2 ] [ (AddQuestion 118 0), (AddQuestion 113 0), (AddQuestion 114 0), (RemoveQuestion 112), (RemoveQuestion 113), (RemoveQuestion 114) ] None)
        , QuestionRecord 102 "Second Checkbox" "desc 1" CheckBox
            (QuestionOptions [ "one mayonaise" ] [ 0 ] [ None, None ] None)
        , QuestionRecord 109 "Budget" "" SubHeading
            (QuestionOptions [ "" ] [ 0 ] [ None ] None)
        , QuestionRecord 112 "Subheading Bacon" "" SubHeading
            (QuestionOptions [ "" ] [ 0 ] [ None ] None)
        , QuestionRecord 118 "" "" EditBox
            (QuestionOptions [ "temporariy content" ] [ 0 ] [ None ] None)
        , QuestionRecord 113 "Subheading Cheese" "" SubHeading
            (QuestionOptions [ "" ] [ 0 ] [ None ] None)
        , QuestionRecord 114 "Subheading Pickles" "" SubHeading
            (QuestionOptions [ "" ] [ 0 ] [ None ] None)
        , QuestionRecord 121 "Subheading DropDown" "" SubHeading
            (QuestionOptions [ "" ] [ 0 ] [ None ] None)
        , QuestionRecord 104 "Edit Box" "This text is the description" EditBox
            (QuestionOptions [ "second one\n first one"] [ 0 ] [ None ] None)
        , QuestionRecord 111 "Add CLIN table" "" Button
            (QuestionOptions [ "" ] [ 0 ] [ (AddQuestion 110 2) ] None)
        , QuestionRecord 107
            "Not a Question"
            "This text is the description"
            NotAQuestion
            (QuestionOptions [ "" ] [ 0 ] [ None ] None)
        , QuestionRecord 108
            "Text Input"
            "This text is the description"
            TextInput
            (QuestionOptions [ "first sample", "", "second sample"] [ 0 ] [ None ] None)
        , QuestionRecord 106
            "First Radio"
            "what do you want to pick?"
            RadioButton
            (QuestionOptions [ "one bacon1", "two cheese1", "three pickles1" ] [ 2 ] [ None, None, None, None, None, None ] None)
        , QuestionRecord 110
            "CLIN table "
            "here description"
            CLINTable
            (QuestionOptions [ "one bacon1", "two cheese1", "three pickles1" ] [ 2 ] [ None, None, None ] None)
        , QuestionRecord 103
            "DropDown"
            ""
            DropDown
            (QuestionOptions [ "NONE|---Please Select Option ----", "EPA|EnvironmentalP", "OPG|Office of Postal Giraffes" ] [ 0 ] [ None ] None)
        ]
    }

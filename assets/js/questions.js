var questions = JSON.stringify(
[
    {
        "uid": 1001
        , "title": "Sample Title"
        , "type": "dropdown"
        , "saveAction": ""
        , "options":
            ["PAN|American"
                , "SIN|Gringo"
            ]
        , "actions":
            [
                [
                    {
                        "action": "AddQuestion"
                        , "number": 1002
                    }
                    ,
                    {
                        "action": "RemoveQuestion"
                        , "number": 1003
                    }
                ]
                ,
                [
                    {
                        "action": "RemoveQuestion"
                        , "number": 1002
                    }
                    ,
                    {
                        "action": "AddQuestion"
                        , "number": 1003
                    }
                ]
            ]
        , "childQuestions": []
    }
]
);
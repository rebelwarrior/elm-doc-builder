module MarkdownBuilder exposing (buildMarkdown)

import Markdown exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model

import CssTranslation exposing (css)

options : Markdown.Options 
options =
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Nothing
    , sanitize = False
    , smartypants = False
    }

buildMarkdown : Model.QuestionRecord -> Html msg
buildMarkdown question = 
    question.text 
        |> List.foldr (++) ""
        |> Markdown.toHtmlWith options [class css.markdown_class ] 
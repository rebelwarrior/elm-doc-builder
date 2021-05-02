module MarkdownBuilder exposing (buildMarkdown)

import CssTranslation exposing (css)
import Html exposing (..)
import Html.Attributes exposing (class)
import Markdown exposing (toHtmlWith)
import Model


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
        |> Markdown.toHtmlWith options [ class css.markdown_class ]

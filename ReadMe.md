# Elm Document Builder

Problem to solve: 
As a User I want to easily modify a set of questions on a questionnaire that the program uses to produce a document. 

Approach to solve it:
Make the program's logic and content be on a separate JSON file that the Elm program slurps at startup and can interpret, including its logic. 

## Demo
The Elm program compiles to JavaScript which can then be hosted with Jekyll on GitHub directly.

Check out the live demo here: https://rebelwarrior.github.io/demo-elm-doc-builder/

Demo Repository here: 
https://github.com/rebelwarrior/demo-elm-doc-builder

## Schema
The program expects two json files: one with the questions in page (simple array of intergers) and the other with a list of all the questions. 

The list of questions is an array containing a "QuestionRecord" object. Each "QuestionRecord" has the following properties:

| required or optional | property | type |
| --- | --- | --- |
|    required | "uid"            | int
|    required | "title"          | string 
|    optional | "text"           | array of strings
|    required | "type"           | string from set list
|    optional | "saveAction"     | string from set list
|    optional | "options"        | array of strings
|    optional | "actions"        | array of arrays of action objects
|    optional | "childQuestions" | array of integers

| property | what it is |
| --- | --- |
| "uid"            | unique identifier for each "question" record
| "title"          | text of the title
| "text"           | description of question and other text
| "type"           | type of question from set list
| "saveAction"     | type of action from set list, when saving this is the action that will be taken.
| "options"        | options of the question record
| "actions"        | list of actions associated with each option of the question record
| "childQuestions" | list of question that will be removed if this question is removed (this is not recursive)

List of available __types__: 
```javascript
[ "checkbox", "radio", "dropdown", "markdown", "editbox", "textbox", 
"textinput", "textarea", "table", "button", "subheading", "notaquestion" ]
```

Each question may have "Action" objects:

| required or optional | property | type |
| --- | --- | --- |
| required | "action"  | string from set list
| optional | "number"  | int 
| optional | "below"   | int  
| optional | "message" | string 
| optional | "options" | array of strings

Depending which action the "optional" parameters are required or ignored. 

| action | required | what it does |
| --- | --- | --- |
| "addquestion"       | "number"            | adds question (number) at bottom of page
| "removequestion"    | "number"            | removes question from page
| "addquestionbelow"  | "number", "below"   | adds question (number) below question (below)
| "replacealloptions" | "number", "options" | replaces all the options of a question (number) 
| "print"             | n/a                 | toggles save action of all questions 

List of __save actions__: 
```javascript 
["savetext", "saveall", "none"]
```

| save action | what it does |
| --- | --- |
| "savetext"  | Keeps the text of the question. 
| "saveall"   | Keeps the whole question. 
| "none"      | Does NOT keep any part of the question. 

## Usage

### Compile to JS

To use: install node.js, elm-lang and run `elm-package install` and install all the packages.

If you have elm-live as well you can use it to compile the JS file and load the html file with: 

`elm-live Main.elm --open --output="elm.js"` 

```bash
elm-live elm/Main.elm --open --output="assets/js/elm.js"
```

else you can compile with `elm-make` or try the `elm-reactor` for a different type of interactive file.


Table should be a collection of Text Input Quesionts...
Also where is the readme for the quesitons?

TODO:
1. [x] Implement Save Actions to Document Creation 
1. [x] Simplify DropDown based on Checkboxex/Radio button pattern 
4. [_] Implement Table (important)
5. [_] Refactor Text Input maybe add validations?
1. [_] Fully implement jekyll theme pattern (low)
2. [_] Fix fade easing of alerts without using js. (if possible)
3. [_] Implement Heading (reimplementation of Subheading)
6. [_] Implement NotAQuestion (also rename) 
7. [_] Verify Accessibility tags
8. [_] Add validation 
9. [_] Use consistent css for question title and question description 

Key Technical problems that had to be overcome:
1. Use a List of Msg rather than just one in 
2. How to sort the list of questions in order (View)
3. How to build a Dropdown
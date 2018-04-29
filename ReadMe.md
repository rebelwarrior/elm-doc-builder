# Elm Document Builder

Problem to solve: 
As a User I want to easily modify a set of questions that the program uses to produce a document. 

Approach to solve it:
Make the program's logic and content be on a separate JSON file that the Elm program slurps at startup and can interpret, including its logic. 

## Schema
The program expects two json files: one with the questions in page (simple array of interger) and the other with a list of all the questions. 

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

list of available types 
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
| --- | --- |
| "addquestion"       | "number"            | adds question (number) at bottom of page
| "removequestion"    | "number"            | removes question from page
| "addquestionbelow"  | "number", "below"   | adds question (number) below question (below)
| "replacealloptions" | "number", "options" | replaces all the options of a question (number)



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
1. [] Fully implement jekyll theme pattern
2. [] Fix fade easing of alerts without using js. (if possible)
3. [] Implement Heading (reimplementation of Subheading)
4. [] Implement Table
5. [] Implement TextInput (presently incomplete)
6. [] Implement NotAQuestion (also rename) 
7. [] Verify Accessibility tags
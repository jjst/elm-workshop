# Elm workshop

In this tutorial we are going to build a clone of the [Lights Out](https://en.wikipedia.org/wiki/Lights_Out_(game)) game using Elm. This is basically a stripped down version of the [Lights Out](https://github.com/mariellefoster/lightsout) game we demoed at Thursday presentations.

## Setup

You will need to install Elm and Git if they're not already on your machine.

Follow the instructions at http://elm-lang.org/install to install Elm and configure your IDE.

Follow your OS's instructions to install git.

Then clone this repository using:

```bash
$ git clone git@github.com:jjst/elm-workshop.git
$ cd elm-workshop
```

If you're lost at any point, you can jump ahead to the next stage of the tutorial using
```
$ git checkout -f -b stage<number>
```

For example, to jump ahead to stage 2, run:
```
$ git checkout -f -b stage2
```

## 0. First Steps

Let's get familiar with Elm and the Elm toolchain a little bit...

### What's Elm?

Elm is a **purely functional**, **strongly typed** language which compiles to Javascript. It is similar in that regard to languages like TypeScript, ClojureScript, Scala.js, but with a syntax strongly inspired by Haskell.

### Why Elm?

* Because it's not Javascript
* Strong type system + purely functional -> no runtime errors 
* Designed for web app dev
* [Fast](http://elm-lang.org/blog/blazing-fast-html)!

### Hello, World!

Create a new file called `Hello.elm`, and paste the following contents in:

```elm
import Html exposing (text)

main =
  text "Hello, World!"
```

What's going on here? As with most languages `main` is the default entry point of Elm programs. We're importing the `text` function from the `Html` module to tell Elm to render `Hello world!` as text inside a web page.

Let's compile this with:

```
$ elm make Hello.elm --output=hello.html
```

This generates a file called `hello.html` that you can open in your favourite web browser.

## Stage 1. Generating HTML and CSS

First things first, running `elm make` each time we make a change isn't very convenient. Fortunately the elm platform comes with a tool to make this easier. Open a separate terminal tab/window, cd to the workshop folder, and run:

```
$ elm reactor
```

This will start a web server that will automatically recompile your Elm code when you refresh the page. If you go to http://localhost:8000/, you should see a list of all elm files in the current folder, and clicking on them will trigger compilation and display any compile errors in your browser.

We'll start off our game by creating one single light by applying CSS styling to an HTML div. Open `Light.elm`. It just contains a bunch of default imports to get us started a little bit faster.

We'll add a main function like we did before, but this time make it look like this:

```elm
main =
    let
        divStyle =
            style
                [ ("height", "100px")
                , ("width", "100px")
                , ("margin", "5px")
                , ("border-radius", "15%")
                , ("background-color", "yellow")
                ]
    in
       div [ divStyle ] []
```

Save and load `Light.elm` in elm reactor by going to 

## Stage 2. Adding state!

That's all cool but this doesn't do much, it's just like a static HTML file! Let's add the ability to toggle the light on or off now.

Elm is purely functional though, so we can't just mutate our view willy-nilly. Instead, Elm programs follow something called the Elm architecture. This might all sound familiar for people coming from Javascript frameworks such as React. The idea is that we're going to handle stage by describing our Model, which kind of messages it can take, and what a new model looks like when a message is received.

Amend `Light.elm` to look like this:

```elm
main =
    App.beginnerProgram
        { model = init
        , update = update
        , view = view
        }

-- MODEL

type Model = On | Off

init : Model
init = Off

-- UPDATE

type Msg
    = Toggle

update : Msg -> Model -> Model
update message model =
    case model of
        On -> Off
        Off -> On

-- VIEW

view : Model -> Html Msg
view model =
    let
        color =
            case model of
                On -> "yellow"
                Off -> "grey"
        divStyle =
            style
                [ ("height", "100px")
                , ("width", "100px")
                , ("margin", "5px")
                , ("border-radius", "15%")
                , ("background-color", color)
                ]
    in
       div [ divStyle, onClick Toggle ] []
```

Reload `Light.elm` in your browser and try clicking on it.

## Stage 3. Scaling it up...

Our light works and can toggle on and off. Now we want to render a 5x5 board of 'em!

To do this we're going to nest components. Our Light works well on its own, and a key component of the Elm architecture is to reuse existing components by nesting them.

First, open `Light.elm` and add the following right on top:

```elm
module Light exposing (..)
```

This is saying that Light is now a module, and that we expose all functions and values in there. You can also remove the main function as we won't need it anymore.

Open `Board.elm`. 

Let's start by adding our Model, which is going to be a list of list of Lights:

```elm
type alias Model = List (List Light.Model)

type alias Coords = (Int, Int)
```

We're also declaring a type alias for 2 dimensional coords as this will come in handy for a bunch of functions.

Add an init function to initialise our Board to every light off:

```elm
init : Model
init =
    Light.init
        |> List.repeat 5
        |> List.repeat 5

```

And a helper function that's going to come handy, don't worry about it for now:

```elm
indexedMap : (Coords -> a -> b) -> List (List a) -> List (List b)
indexedMap f board =
    board
        |> List.indexedMap (\ i row -> row |> List.indexedMap (\ j cellModel -> f (i, j) cellModel))
```

For update, we're (again) going to have a single type of message, which we're going to call `ToggleAt`. However, this time we'll need to pass in the coordinates of which Light was toggled, because we have a lot of them!

```elm
type Msg
    = ToggleAt Coords Light.Msg
```

Our update function looks like this:

```elm
update : Msg -> Model -> Model
update message model =
    case message of
        ToggleAt toggleCoords lightMessage ->
            indexedMap (\ coords cellModel ->
                if List.member coords (neighbors toggleCoords) then
                    (Light.update lightMessage cellModel)
                else
                    cellModel
            ) model
```

And in view:

```elm
view :  Model -> Html Msg
view model =
    let
        rows = List.indexedMap
                (\i row -> tr [] (row |> List.indexedMap (\j cellModel -> td [] [ (renderLight (i, j) cellModel) ])))
                model
    in
       table [] rows

renderLight : Coords -> Light.Model -> Html Msg
renderLight (i,j) cellModel =
    cellModel
        |> Light.view
        |> App.map (ToggleAt (i, j))
```

## Stage 4. Toggling neighbors

OK, we have a board full of lights that we can toggle. All that's left to do is to make all of a light's neighbors toggle at the same time!

Add the following functions to the model to determine the neighbors of a Light:

```elm
neighbors : Coords -> List Coords
neighbors (i, j) = [ (i, j), (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1) ]
```

Then, update the update function like so:

```elm
update : Msg -> Model -> Model
update message model =
    case message of
        ToggleAt toggleCoords lightMessage ->
            indexedMap (\ coords cellModel ->
                if List.member coords (neighbors toggleCoords) then
                    (Light.update lightMessage cellModel)
                else
                    cellModel
            ) model
```

Refresh `Board.elm` in your browser. Everything should work! 

## Going further

Here are a bunch of suggestions 

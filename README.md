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

## Stage 3. Scaling it up...



## Stage 4. Toggling neighbors

## Going further

Here are a bunch of suggestions 

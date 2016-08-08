# Elm workshop

In this tutorial we are going to build a clone of the [Lights Out](https://en.wikipedia.org/wiki/Lights_Out_(game)) game using Elm.

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

## Stage 2. Adding state!

## Stage 3. Scaling it up...

## Stage 4. Toggling neighbors

## Going further

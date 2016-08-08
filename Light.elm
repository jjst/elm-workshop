module Light exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


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

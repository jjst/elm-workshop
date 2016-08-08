import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Html.App as App

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

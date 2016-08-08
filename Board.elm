import Html exposing (Html, div, table, tr, td, text)
import Html.App as App
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Light
import List

main =
    App.beginnerProgram
        { model = init
        , update = update
        , view = view
        }

-- MODEL

type alias Coords = (Int, Int)

type alias Model = List (List Light.Model)

init : Model
init =
    Light.init
        |> List.repeat 5
        |> List.repeat 5

indexedMap : (Coords -> a -> b) -> List (List a) -> List (List b)
indexedMap f board =
    board
        |> List.indexedMap (\ i row -> row |> List.indexedMap (\ j cellModel -> f (i, j) cellModel))

neighbors : Coords -> List Coords
neighbors (i, j) = [ (i, j), (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1) ]


-- UPDATE

type Msg
    = ToggleAt Coords Light.Msg

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


-- VIEW

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

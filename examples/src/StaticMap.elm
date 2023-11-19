module StaticMap exposing (..)

import Browser
import Html
import Html.Attributes
import SlippyMap



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    SlippyMap.Map


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}
    , Cmd.none
    )



-- UPDATE


type Msg
    = MapMsg SlippyMap.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MapMsg mapMsg ->
            let
                ( mapModel, mapNextMsg ) =
                    SlippyMap.update mapMsg model
            in
            ( mapModel, Cmd.map MapMsg mapNextMsg )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions map =
    map
        |> SlippyMap.subscriptions
        |> Sub.map MapMsg



-- VIEW


view : Model -> Html.Html Msg
view model =
    Html.div
        [ Html.Attributes.style "width" "512px"
        , Html.Attributes.style "height" "512px"
        ]
        [ SlippyMap.view model |> Html.map MapMsg ]

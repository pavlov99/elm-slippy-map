module SlippyMap exposing (GeoCoordinate, Map, Msg, ProjectedCoordinate, subscriptions, update, view)

import Html
import Html.Attributes


type alias GeoCoordinate =
    { lat : Float
    , lon : Float
    }


type alias ProjectedCoordinate =
    { easting : Float
    , northing : Float
    }


type alias Map =
    {}


type Msg
    = NoOp


update : Msg -> Map -> ( Map, Cmd Msg )
update msg map =
    ( map, Cmd.none )


subscriptions : Map -> Sub Msg
subscriptions map =
    Sub.none


view : Map -> Html.Html Msg
view map =
    Html.div
        [ Html.Attributes.style "width" "100%"
        , Html.Attributes.style "height" "100%"
        , Html.Attributes.style "position" "relative"
        ]
        []

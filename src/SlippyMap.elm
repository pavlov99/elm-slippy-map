module SlippyMap exposing (GeoCoordinate, Map, Msg, ProjectedCoordinate, osmMap, subscriptions, update, view)

import Html
import Html.Attributes
import SlippyMap.Pixel as Pixel
import Svg
import Svg.Attributes



-- MODEL


type alias GeoCoordinate =
    { lat : Float
    , lon : Float
    }


type alias ProjectedCoordinate =
    { easting : Float
    , northing : Float
    }


type alias Tile =
    { x : Int, y : Int }


type alias TileLayer =
    { urlTemplate : String
    }


tileSize =
    256


type alias Map =
    { size : { width : Float, height : Float }
    , center : GeoCoordinate
    , zoom : Int
    , tileLayers : List TileLayer
    }


osmMap : Map
osmMap =
    { size = { width = 0, height = 0 }
    , center = { lat = 0, lon = 0 }
    , zoom = 0
    , tileLayers =
        [ { urlTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png" }
        ]
    }



-- UPDATE


type Msg
    = NoOp


update : Msg -> Map -> ( Map, Cmd Msg )
update msg map =
    ( map, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Map -> Sub Msg
subscriptions map =
    Sub.none



-- VIEW


view : Map -> Html.Html Msg
view map =
    Html.div
        [ Html.Attributes.style "width" "100%"
        , Html.Attributes.style "height" "100%"
        , Html.Attributes.style "position" "relative"
        ]
        [ viewTiles map
        , viewAttribution
        ]


viewTiles : Map -> Html.Html Msg
viewTiles map =
    let
        x =
            0.5 + map.center.lon / 360

        y =
            0.5 - logBase e (tan (pi / 4 + degrees map.center.lat / 2)) / 2 / pi

        centerTileIndex =
            Pixel.Pixel x y
                |> Pixel.scale (2 ^ toFloat map.zoom)
                |> Pixel.floor

        intraTileShift =
            Pixel.sub (Pixel.Pixel x y |> Pixel.scale (2 ^ toFloat map.zoom)) (Pixel.toPixel centerTileIndex)
                |> Pixel.scale tileSize

        shift =
            Pixel.sub (Pixel.Pixel (map.size.width / 2) (map.size.height / 2)) intraTileShift

        tilesLeft =
            ceiling (shift.x / tileSize)

        tilesRight =
            (map.size.width - shift.x) / tileSize |> floor

        tilesUp =
            ceiling (shift.y / tileSize)

        tilesDown =
            (map.size.height - shift.y) / tileSize |> floor
    in
    Html.div
        [ Html.Attributes.style "position" "absolute" ]
        [ Svg.svg
            [ Svg.Attributes.width (String.fromFloat map.size.width)
            , Svg.Attributes.height (String.fromFloat map.size.height)

            -- Use vertical-align for images within absolutely positioned blocks to
            -- prevent parent block being 4px taller. Alternatively change inline
            -- image element to block.
            , Html.Attributes.style "display" "block"
            ]
            (List.concatMap
                (\a ->
                    List.map
                        (\b ->
                            Svg.image
                                [ Svg.Attributes.xlinkHref (toUrl "https://tile.openstreetmap.org/{z}/{x}/{y}.png" map.zoom { x = centerTileIndex.x + a, y = centerTileIndex.y + b })
                                , Svg.Attributes.width (String.fromInt tileSize)
                                , Svg.Attributes.height (String.fromInt tileSize)
                                , Svg.Attributes.transform ("translate(" ++ String.fromFloat (shift.x + toFloat a * tileSize) ++ ", " ++ String.fromFloat (shift.y + toFloat b * tileSize) ++ ")")
                                ]
                                []
                        )
                        (List.range -tilesLeft tilesRight)
                )
                (List.range -tilesUp tilesDown)
            )
        ]


viewAttribution : Html.Html Msg
viewAttribution =
    Html.div
        [ Html.Attributes.style "position" "absolute"
        , Html.Attributes.style "bottom" "0"
        , Html.Attributes.style "right" "0"
        , Html.Attributes.style "background-color" "rgba(255, 255, 255, .5)"
        , Html.Attributes.style "padding" "1px 4px"
        ]
        [ Html.span []
            [ Html.text "© "
            , Html.a
                [ Html.Attributes.href "https://www.openstreetmap.org/copyright"
                , Html.Attributes.target "_blank"
                , Html.Attributes.style "text-decoration" "none"
                ]
                [ Html.text "OpenStreetMap" ]
            , Html.text " contributors"
            ]
        ]


toUrl : String -> Int -> Tile -> String
toUrl urlTemplate zoom { x, y } =
    urlTemplate
        |> String.replace "{z}" (String.fromInt zoom)
        |> String.replace "{x}" (String.fromInt x)
        |> String.replace "{y}" (String.fromInt y)

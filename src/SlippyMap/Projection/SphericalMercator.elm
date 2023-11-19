module SlippyMap.Projection.SphericalMercator exposing (..)

import SlippyMap exposing (GeoCoordinate, ProjectedCoordinate)


project : Float -> Float -> Float -> Float -> Float -> GeoCoordinate -> ProjectedCoordinate
project _ lon0 radius fe fn { lat, lon } =
    { easting = fe + radius * (lon - lon0)
    , northing = fn + radius * logBase e (tan (pi / 4 + lat / 2))
    }


unproject : Float -> Float -> Float -> Float -> Float -> ProjectedCoordinate -> GeoCoordinate
unproject _ lon0 radius fe fn { easting, northing } =
    let
        d =
            (fn - northing) / radius
    in
    { lat = pi / 2 - 2 * atan (e ^ d)
    , lon = (easting - fe) / radius + lon0
    }

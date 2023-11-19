module SlippyMap exposing (GeoCoordinate, ProjectedCoordinate)


type alias GeoCoordinate =
    { lat : Float
    , lon : Float
    }


type alias ProjectedCoordinate =
    { easting : Float
    , northing : Float
    }

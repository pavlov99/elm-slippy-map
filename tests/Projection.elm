module Projection exposing (..)

import Expect
import SlippyMap.Projection.SphericalMercator
import Test


suite : Test.Test
suite =
    Test.describe "Projection.SphericalMercator"
        [ Test.describe "project"
            [ Test.test "reference example" <|
                \_ ->
                    Expect.all
                        [ .easting >> Expect.within (Expect.Absolute 0.005) -11156569.9
                        , .northing >> Expect.within (Expect.Absolute 0.005) 2796869.94
                        ]
                        (SlippyMap.Projection.SphericalMercator.project
                            0
                            0
                            6371007
                            0
                            0
                            { lat = 0.42554246, lon = -1.751147016 }
                        )
            ]
        , Test.describe "unproject"
            [ Test.test "reference example" <|
                \_ ->
                    Expect.all
                        [ .lat >> Expect.within (Expect.Absolute 5.0e-10) 0.42554246
                        , .lon >> Expect.within (Expect.Absolute 5.0e-10) -1.751147016
                        ]
                        (SlippyMap.Projection.SphericalMercator.unproject
                            0
                            0
                            6371007
                            0
                            0
                            { easting = -11156569.9, northing = 2796869.94 }
                        )
            ]
        ]

module SlippyMap.Pixel exposing (..)


type alias Pixel =
    { x : Float, y : Float }


scale : Float -> Pixel -> Pixel
scale factor { x, y } =
    { x = factor * x
    , y = factor * y
    }


add : Pixel -> Pixel -> Pixel
add p1 p2 =
    { x = p1.x + p2.x, y = p1.y + p2.y }


sub : Pixel -> Pixel -> Pixel
sub p1 p2 =
    { x = p1.x - p2.x, y = p1.y - p2.y }


floor : Pixel -> { x : Int, y : Int }
floor { x, y } =
    { x = Basics.floor x, y = Basics.floor y }


toPixel : { x : Int, y : Int } -> Pixel
toPixel { x, y } =
    { x = toFloat x, y = toFloat y }

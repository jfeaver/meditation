module FA exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA


fa : String -> Html msg
fa icon =
    H.i [ HA.class ("fa fa-" ++ icon) ] []

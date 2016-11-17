module FA exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA


fa : String -> Maybe String -> Html msg
fa icon mPlaceholder =
    case mPlaceholder of
        Nothing ->
            H.i [ HA.class ("fa fa-" ++ icon) ] []

        Just placeholder ->
            H.i [ HA.class ("fa fa-" ++ icon) ] [ H.text placeholder ]

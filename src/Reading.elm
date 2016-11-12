module Reading
    exposing
        ( Reading
        , none
        , get
        , view
        )

import Time exposing (Time)
import Html as H exposing (..)


-- MODEL


type Reading
    = Reading
        { time : Time
        , verses : List Verse
        , paragraphs : List String
        }


type alias Verse =
    { passage : String
    , reference : Reference
    }


type alias Reference =
    { book : String
    , chapter : String
    , verse : String
    }


none : Reading
none =
    Reading
        { time = 0
        , verses = []
        , paragraphs = []
        }



-- EFFECTS


get : Time -> Reading
get time =
    none



-- VIEW


view : Reading -> Html msg
view reading =
    H.div [] []

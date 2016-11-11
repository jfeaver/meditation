module Reading
    exposing
        ( Reading
        , get
        , view
        )

import Time exposing (Time)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)


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



-- EFFECTS


get : Time -> Reading
get =
    Debug.crash "Not Implemented"



-- VIEW


view : Reading -> Html msg
view reading =
    Debug.crash "Not Implemented"

module Reading
    exposing
        ( Reading
        , none
        , get
        , view
        )

import Time exposing (Time)
import Html as H exposing (Html)
import Task exposing (Task)
import ReadingTime
import String


-- MODEL


type alias Reading =
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
    { time = 0
    , verses = []
    , paragraphs = []
    }



-- EFFECTS


get : Time -> Task Time Reading
get time =
    Task.succeed { none | time = time }



-- VIEW


view : Reading -> Html msg
view reading =
    H.div [] [ H.text (url reading.time) ]



-- HELPERS


url : Time -> String
url time =
    let
        readingTime =
            ReadingTime.translated (ReadingTime.fromTime time)
    in
        String.toLower
            (List.foldr
                (++)
                ""
                [ "/meditation/readings/"
                , readingTime.month
                , "_"
                , (String.padLeft 2 '0' readingTime.day)
                , "_"
                , readingTime.timeOfDay
                , ".json"
                ]
            )

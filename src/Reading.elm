module Reading
    exposing
        ( Reading
        , url
        )

import ReadingTime exposing (ReadingTime)
import Verse exposing (Verse)
import Http
import String


type alias Reading =
    { verses : List Verse
    , reading: List String
    }


url : ReadingTime -> String
url readingTime =
    "/meditation/assets/readings/"
        ++ (readingTime |> ReadingTime.month |> String.toLower)
        ++ "_"
        ++ (toString readingTime.day)
        ++ ".json"

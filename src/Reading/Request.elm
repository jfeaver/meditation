module Reading.Request exposing (get)

import String
import Time exposing (Time)
import Task exposing (Task)
import Json.Decode exposing (..)
import Http
import Reading exposing (Reading)
import ReadingTime


-- REQUESTS


get : Time -> Http.Request Reading
get time =
    Http.get (url time) decodeReading



-- DECODERS


decodeReading : Decoder Reading
decodeReading =
    map2 Reading
        (field "verses" (list decodeVerse))
        (field "reading" (list string))


decodeVerse : Decoder Reading.Verse
decodeVerse =
    map2 Reading.Verse
        (field "passage" string)
        (field "reference" decodeReference)


decodeReference : Decoder Reading.Reference
decodeReference =
    map3 Reading.Reference
        (field "book" string)
        (field "chapter" string)
        (field "verse" string)



-- HELPERS


url : Time -> String
url time =
    let
        readingTime =
            ReadingTime.translated (ReadingTime.fromTime time)
    in
        String.toLower
            (String.concat
                [ "/meditation/readings/"
                , readingTime.month
                , "_"
                , (String.padLeft 2 '0' readingTime.day)
                , "_"
                , readingTime.timeOfDay
                , ".json"
                ]
            )

module Reading.Request exposing (get)

import String
import Time exposing (Time)
import Task exposing (Task)
import Json.Decode exposing (..)
import Http
import Reading exposing (Reading)
import ReadingTime


-- EFFECTS


get : Time -> Task Http.Error Reading
get time =
    Http.get decodeReading (url time)



-- DECODERS


decodeReading : Decoder Reading
decodeReading =
    object2 Reading
        ("verses" := list decodeVerse)
        ("reading" := list string)


decodeVerse : Decoder Reading.Verse
decodeVerse =
    object2 Reading.Verse
        ("passage" := string)
        ("reference" := decodeReference)


decodeReference : Decoder Reading.Reference
decodeReference =
    object3 Reading.Reference
        ("book" := string)
        ("chapter" := string)
        ("verse" := string)



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

module Reading
    exposing
        ( Reading
        , Verse
        , Reference
        , Error
        , model
        , url
        , request
        )

import ReadingTime exposing (ReadingTime)
import Http
import Task exposing (Task)
import String
import Json.Decode exposing (..)


-- MODEL


type alias Reading =
    { verses : List Verse
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


type alias Error =
    Http.Error


model : Reading
model =
    { verses = []
    , paragraphs = []
    }


url : ReadingTime -> String
url readingTime =
    List.foldr (++)
        ""
        [ "/meditation/readings/"
        , (readingTime |> ReadingTime.month |> String.toLower)
        , "_"
        , (String.padLeft 2 '0' (readingTime.day |> toString))
        , "_"
        , (readingTime |> ReadingTime.timeOfDay |> String.toLower)
        , ".json"
        ]


request : ReadingTime -> Task Error Reading
request readingTime =
    Http.get decodeReading (url readingTime)


decodeReading : Decoder Reading
decodeReading =
    object2 Reading
        ("verses" := list decodeVerse)
        ("reading" := list string)


decodeVerse : Decoder Verse
decodeVerse =
    object2 Verse
        ("passage" := string)
        ("reference" := decodeReference)


decodeReference : Decoder Reference
decodeReference =
    object3 Reference
        ("book" := string)
        ("chapter" := string)
        ("verse" := string)

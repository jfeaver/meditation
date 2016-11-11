module Reading exposing (..)

import Time exposing (Time)
import EnglishReadingTime
import Http
import Html exposing (..)
import Html.Attributes exposing (..)



-- MODEL


type alias Model =
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


model : Model
model =
    { time = 0
    , verses = []
    , paragraphs = []
    }



-- VIEW


view : msg -> Model -> Html msg
view msg model =
    div [ class "article" ]
        [ h2 [] [ text <| title model.readingTime ]
        , div [ class "verses" ]
        (List.map verse model.reading.verses)
        , div [ class "reading-body" ]
        (List.map paragraph model.reading.paragraphs)
        ]


title : Model -> String
title model =
    List.foldr (++)
        ""
        [ "Reading for: "
        , EnglishReadingTime.timeOfDay model.time
        , ", "
        , EnglishReadingTime.month model.time
        , " "
        , EnglishReadingTime.day model.time
        ]

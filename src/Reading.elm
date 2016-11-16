module Reading
    exposing
        ( Reading
        , Verse
        , Reference
        , none
        , view
        )

import Html as H exposing (Html)
import Html.Attributes as HA
import Time exposing (Time)
import Json.Encode
import ReadingTime


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


none : Reading
none =
    { verses = []
    , paragraphs = []
    }



-- VIEW


view : Time -> Reading -> Html msg
view time reading =
    H.div [ HA.class "article" ]
        [ H.h2 [] [ H.text <| title time ]
        , H.div [ HA.class "verses" ]
            (List.map verse reading.verses)
        , H.div [ HA.class "reading-body" ]
            (List.map paragraph reading.paragraphs)
        ]


title : Time -> String
title time =
    let
        tReadingTime =
            ReadingTime.translated (ReadingTime.fromTime time)
    in
        List.foldr (++)
            ""
            [ "Reading for: "
            , tReadingTime.timeOfDay
            , ", "
            , tReadingTime.month
            , " "
            , tReadingTime.day
            ]


verse : Verse -> Html msg
verse verse =
    H.blockquote
        []
        [ H.p [] [ H.text verse.passage ]
        , H.p
            [ HA.class "citation"
            ]
            [ H.text
                (List.foldr (++)
                    ""
                    [ "-"
                    , verse.reference.book
                    , " "
                    , verse.reference.chapter
                    , ":"
                    , verse.reference.verse
                    ]
                )
            ]
        ]


paragraph : String -> Html msg
paragraph readingParagraph =
    H.p [ HA.property "innerHTML" (Json.Encode.string readingParagraph) ] []

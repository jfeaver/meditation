module Reading
    exposing
        ( Reading
        , model
        , url
        , view
        )

import ReadingTime exposing (ReadingTime)
import Verse exposing (Verse)
import Http
import String
import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Reading =
    { verses : List Verse
    , paragraphs : List String
    }


model : Reading
model =
    { verses = []
    , paragraphs = []
    }


url : ReadingTime -> String
url readingTime =
    "/meditation/assets/readings/"



{-
   ++ (readingTime |> ReadingTime.month |> String.toLower)
   ++ "_"
   ++ (String.padLeft 2 ' ' (readingTime.day |> toString))
   ++ "_"
   ++ (readingTime |> ReadingTime.timeOfDay |> String.toLower)
   ++ ".json"
-}
-- VIEW


view : Reading -> Html msg
view model =
    div
        []
        [ div
            [ class "verses"
            ]
            (List.map Verse.view model.verses)
        , div
            [ class "reading"
            ]
            (List.map viewParagraph model.paragraphs)
        ]


viewParagraph : String -> Html msg
viewParagraph paragraph =
    p [] []

module Reading
    exposing
        ( Reading
        , Error
        , model
        , url
        , request
        )

import ReadingTime exposing (ReadingTime)
import Verse exposing (Verse)
import Http
import Task exposing (Task)


-- MODEL


type alias Reading =
    { verses : List Verse
    , paragraphs : List String
    }


type Error = Http.Error



model : Reading
model =
    { verses = []
    , paragraphs = []
    }


url : ReadingTime -> String
url readingTime =
    "/meditation/assets/readings/"


request : ReadingTime -> Task Error Reading
request readingTime =
    Task.succeed model

{-
   ++ (readingTime |> ReadingTime.month |> String.toLower)
   ++ "_"
   ++ (String.padLeft 2 ' ' (readingTime.day |> toString))
   ++ "_"
   ++ (readingTime |> ReadingTime.timeOfDay |> String.toLower)
   ++ ".json"
-}
-- VIEW


{-
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
-}

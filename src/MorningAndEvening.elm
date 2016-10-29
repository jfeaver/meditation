port module MorningAndEvening exposing (init, view, update)

import Reading exposing (Reading)
import ReadingTime exposing (ReadingTime)
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode


-- MODEL


type alias Model =
    { readingTime : ReadingTime
    , reading : Reading
    }


model : Model
model =
    { readingTime = ReadingTime.model
    , reading = Reading.model
    }


init : ( Model, Cmd Msg )
init =
    ( model, initReadingTime )



-- UPDATE


type Msg
    = SetReadingTime ReadingTime
    | ReadingRequestFailed Reading.Error
    | SetReading Reading


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetReadingTime readingTime ->
            ( { model | readingTime = readingTime }
            , getReading readingTime
            )

        ReadingRequestFailed error ->
            let
                _ = Debug.log "error" (toString error)
            in
                ( model, Cmd.none )

        SetReading reading ->
            ( { model | reading = reading }, Cmd.none )



-- EFFECTS


initReadingTime : Cmd Msg
initReadingTime =
    Task.perform SetReadingTime SetReadingTime ReadingTime.now


getReading : ReadingTime -> Cmd Msg
getReading readingTime =
    Task.perform ReadingRequestFailed SetReading (Reading.request readingTime)



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ id "main"
        ]
        [ h2 [] [ text <| title model.readingTime ]
        , div [ class "verses" ]
            (List.map verse model.reading.verses)
        , div [ class "reading-body" ]
            (List.map paragraph model.reading.paragraphs)
        ]


title : ReadingTime -> String
title readingTime =
    List.foldr (++)
        ""
        [ "Reading for: "
        , ReadingTime.timeOfDay readingTime
        , ", "
        , ReadingTime.month readingTime
        , " "
        , toString readingTime.day
        ]


verse : Reading.Verse -> Html Msg
verse readingVerse =
    blockquote
        []
        [ p [] [ text readingVerse.passage ]
        , p
            [ class "citation"
            ]
            [ text
                (List.foldr (++) ""
                    [ "-"
                    , readingVerse.reference.book
                    , " "
                    , readingVerse.reference.chapter
                    , ":"
                    , readingVerse.reference.verse
                    ]
                )
            ]
        ]


paragraph : String -> Html Msg
paragraph readingParagraph =
    p [ property "innerHTML" (Json.Encode.string readingParagraph) ] []

port module MorningAndEvening exposing (init, view, update)

import Reading exposing (Reading)
import ReadingTime
import Task
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions, defaultOptions)
import Json.Encode


-- MODEL


type alias Model =
    { readingTime : ReadingTime.Model
    , reading : Reading
    , displayReadingTimeSelect : Bool
    }


model : Model
model =
    { readingTime = ReadingTime.model
    , reading = Reading.model
    , displayReadingTimeSelect = False
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.map ToReadingTime ReadingTime.initCmd )



-- UPDATE


type Msg
    = ToReadingTime ReadingTime.Msg
    | ReadingRequestFailed Reading.Error
    | SetReading Reading
    | ClickOut


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToReadingTime readingTimeMsg ->
            let
                ( readingTime, readingTimeCmd ) =
                    ReadingTime.update readingTimeMsg model.readingTime

            in
                ( { model | readingTime = readingTime }
                , getReading readingTime
                )

        ReadingRequestFailed error ->
            let
                _ =
                    Debug.log "error" (toString error)
            in
                ( model, Cmd.none )

        SetReading reading ->
            ( { model | reading = reading }, Cmd.none )

        ClickOut ->
            let
                ( readingTime, readingTimeCmd ) =
                    ReadingTime.update ReadingTime.HideSelect model.readingTime

            in
                ( { model | readingTime = readingTime }
                , Cmd.map ToReadingTime readingTimeCmd
                )



-- EFFECTS


getReading : ReadingTime.Model -> Cmd Msg
getReading readingTime =
    Task.perform ReadingRequestFailed SetReading (Reading.request readingTime.readingTime)



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "main", onClick ClickOut ]
        [ div [ class "article" ]
            [ h2 [] [ text <| title model.readingTime ]
            , div [ class "verses" ]
                (List.map verse model.reading.verses)
            , div [ class "reading-body" ]
                (List.map paragraph model.reading.paragraphs)
            ]
        , Html.App.map ToReadingTime (ReadingTime.toggleNode model.readingTime)
        , Html.App.map ToReadingTime (ReadingTime.selectTool model.readingTime)
        , Html.App.map ToReadingTime (ReadingTime.navigation model.readingTime)
        ]


title : ReadingTime.ReadingTime -> String
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
                (List.foldr (++)
                    ""
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

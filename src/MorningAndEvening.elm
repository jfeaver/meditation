port module MorningAndEvening exposing (init, view, update)

import Reading exposing (Reading)
import ReadingTime exposing (ReadingTime)
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


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
            ( model, getReading model.readingTime )

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
        [ class "container"
        ]
        [ div
            [ id "main"
            ]
            [ h2 [] [ text <| title model.readingTime ]
            ]
          {-
             , button [ onClick (UpdateReading Reading.ToggleMorningEvening) ] [ text "toggle" ]
             , Reading.view Reading.model
             ]
          -}
        , div
            [ id "footer"
            ]
            []
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

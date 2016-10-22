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


setReadingTime : ReadingTime -> Msg
setReadingTime readingTime =
    SetReadingTime readingTime


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        SetReadingTime readingTime ->
            ( { model | readingTime = readingTime }, Cmd.none )



-- EFFECTS


initReadingTime : Cmd Msg
initReadingTime =
    Task.perform setReadingTime setReadingTime ReadingTime.now



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

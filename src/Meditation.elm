module Meditation exposing (..)

import Time exposing (Time)
import EnglishReadingTime
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Task
import TimeSelect
import Reading



-- MODEL


type alias Model =
    { time : Time
    , timeSelect : TimeSelect.Model
    , reading : Reading.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( timeSelect, timeSelectCmd ) =
            TimeSelect.init

    in
        { time = 506502000000
        , timeSelect = timeSelect
        , reading = Reading.model
        }
        ! [ Cmd.map ToTimeSelect timeSelectCmd ]



-- UPDATE


type Msg
    = SetTime Time
    | ToTimeSelect TimeSelect.Msg
    | ToReading Reading.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime time ->
            ( { model | time = time }
            , Cmd.none
            )

        ToReading readingMsg ->
            let
                ( reading, readingCmd ) =
                    Reading.update readingMsg model.reading

            in
                { model | reading = reading }
                !
                [ Cmd.map ToReading readingCmd ]

        ToTimeSelect timeSelectMsg ->
            let
                ( timeSelect, timeSelectCmd ) =
                    TimeSelect.update timeSelectMsg model.timeSelect

                succeedWithTime = Task.succeed timeSelect.time
                succeedWithReadingTime = Task.succeed (Reading.NewReadingTime timeSelect.time)

            in
                { model | timeSelect = timeSelect }
                !
                [ Cmd.map ToTimeSelect timeSelectCmd
                , Task.perform SetTime SetTime succeedWithTime
                , Task.perform ToReading ToReading succeedWithReadingTime
                ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text (title model)
        , Html.App.map ToTimeSelect <| TimeSelect.view model.timeSelect
        , Html.App.map ToReading <| Reading.view model.reading
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

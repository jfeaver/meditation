module Meditation exposing (..)

import Time exposing (Time)
import Date
import DatePicker exposing (DatePicker)
import Reading exposing (Reading)
import Html as H exposing (Html)
import Html.Events as HE
import Html.App
import Task
import TimeOfDay


-- MODEL


type alias Model =
    { time : Time
    , reading : Reading
    , datePicker : DatePicker
    }


init : ( Model, Cmd Msg )
init =
    let
        ( datePicker', datePickerCmd ) =
            DatePicker.init DatePicker.defaultSettings

        startTime =
            0
    in
        { time = startTime
        , reading = Reading.none
        , datePicker = datePicker'
        }
            ! [ Task.perform identity (SetTime startTime) Time.now
              , Cmd.map ToDatePicker datePickerCmd
              ]



-- UPDATE


type Msg
    = SetTime Time Time
    | SetReading Reading
    | AlertReadingLoadError Time Time
    | ToDatePicker DatePicker.Msg
    | ToggleTimeOfDay


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime previousTime time ->
            ( { model | time = time }
            , Task.perform (AlertReadingLoadError previousTime) SetReading (Reading.get time)
            )

        SetReading reading ->
            ( { model | reading = reading }
            , Cmd.none
            )

        AlertReadingLoadError previousTime failedTime ->
            ( { model | time = previousTime }
            , Cmd.none
            )

        ToggleTimeOfDay ->
            ( model, setTime model.time (TimeOfDay.toggle model.time) )

        ToDatePicker msg ->
            let
                ( datePicker', datePickerCmd, mDate ) =
                    DatePicker.update msg model.datePicker

                time =
                    case mDate of
                        Nothing ->
                            model.time

                        Just date ->
                            Date.toTime date
            in
                { model | datePicker = datePicker' }
                    ! [ setTime model.time time
                      , Cmd.map ToDatePicker datePickerCmd
                      ]



-- EFFECTS


setTime : Time -> Time -> Cmd Msg
setTime previousTime newTime =
    Task.perform identity (SetTime previousTime) (Task.succeed newTime)



-- VIEW


view : Model -> Html Msg
view model =
    H.div []
        [ H.text (toString model.time)
        , H.span [ HE.onClick ToggleTimeOfDay ] [ H.text "Toggle" ]
        , Html.App.map ToDatePicker (DatePicker.view model.datePicker)
        , Reading.view model.reading
        ]

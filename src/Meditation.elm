module Meditation exposing (..)

import Time exposing (Time)
import Date
import DatePicker exposing (DatePicker)
import Reading exposing (Reading)
import Html as H exposing (Html)
import Html.App
import Task


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
    in
        { time = 0
        , reading = Reading.none
        , datePicker = datePicker'
        }
            ! [ Task.perform identity SetTime Time.now
              , Cmd.map ToDatePicker datePickerCmd
              ]



-- UPDATE


type Msg
    = SetTime Time
    | ToDatePicker DatePicker.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime time ->
            ( { model | time = time }
            , Cmd.none
            )

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
                    ! [ Task.perform identity SetTime (Task.succeed time)
                      , Cmd.map ToDatePicker datePickerCmd
                      ]



-- VIEW


view : Model -> Html Msg
view model =
    H.div []
        [ Html.App.map ToDatePicker (DatePicker.view model.datePicker)
        ]

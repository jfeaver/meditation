module TimeSelect exposing (..)

import Time exposing (Time)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Date
import DatePicker exposing (defaultSettings)
import Task


type alias Model =
    { datePicker : DatePicker.DatePicker
    , time : Time
    }


type Msg
    = SetTime Time
    | ToDatePicker DatePicker.Msg


init : ( Model, Cmd Msg )
init =
    let
        ( datePicker, datePickerCmd ) =
            DatePicker.init DatePicker.defaultSettings

        commands =
            [ Cmd.map ToDatePicker datePickerCmd
            , Task.perform SetTime SetTime Time.now
            ]
    in
        { datePicker = datePicker
        , time = 506502000000
        }
            ! commands



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime time ->
            let
                settings =
                    { defaultSettings | pickedDate = Just <| Date.fromTime time }

                ( datePicker, datePickerCmd ) =
                    DatePicker.init settings
            in
                ( { model
                    | time = time
                    , datePicker = datePicker
                  }
                , Cmd.map ToDatePicker datePickerCmd
                )

        ToDatePicker datePickerMsg ->
            let
                ( datePicker, datePickerCmd, mDate ) =
                    DatePicker.update datePickerMsg model.datePicker

            in
                case mDate of
                    Just date ->
                        ( model, Task.perform SetTime SetTime (Task.succeed <| Date.toTime date) )

                    Nothing ->
                        ( { model | datePicker = datePicker }
                        , Cmd.map ToDatePicker datePickerCmd
                        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.App.map ToDatePicker <| DatePicker.view model.datePicker
        ]

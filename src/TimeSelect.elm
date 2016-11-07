module TimeSelect exposing (..)

import Time exposing (Time)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Date
import DatePicker


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

    in
        { datePicker = datePicker
        , time = 0
        }
        ! [ Cmd.map ToDatePicker datePickerCmd ]



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetTime time ->
            ( { model | time = time }
            , Cmd.none )

        ToDatePicker datePickerMsg ->
            let
                (datePicker, datePickerCmd, mDate) =
                    DatePicker.update datePickerMsg model.datePicker

                time =
                    case mDate of
                        Nothing ->
                            model.time

                        Just date ->
                            Date.toTime date

            in
                ( { model | datePicker = datePicker, time = time }
                , Cmd.map ToDatePicker datePickerCmd )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.App.map ToDatePicker <| DatePicker.view model.datePicker
        ]

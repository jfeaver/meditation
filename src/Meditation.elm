module Meditation exposing (..)

import Time exposing (Time)
import Date exposing (Date)
import DatePicker exposing (DatePicker)
import Reading exposing (Reading)
import Html as H exposing (Html)
import Html.Events as HE
import Html.App
import Task
import ReadingTime


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
        { time = initTime
        , reading = Reading.none
        , datePicker = datePicker'
        }
            ! [ Task.perform identity (SetTime initTime) Time.now
              , Cmd.map (ToDatePicker True) datePickerCmd
              ]


initTime : Time
initTime =
    0



-- UPDATE


type Msg
    = SetTime Time Time
    | SetReading Reading
    | AlertReadingLoadError Time Time
    | ToDatePicker Bool DatePicker.Msg
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
            let
                mDate =
                    if previousTime == initTime then
                        Nothing
                    else
                        Just (Date.fromTime previousTime)

                settings =
                    DatePicker.defaultSettings

                ( datePicker, datePickerCmd ) =
                    DatePicker.init { settings | pickedDate = mDate }
            in
                { model
                    | time = previousTime
                    , datePicker = datePicker
                }
                    ! [ Cmd.map (ToDatePicker False) datePickerCmd ]

        ToggleTimeOfDay ->
            ( model, setTime model.time (ReadingTime.toggle model.time) )

        ToDatePicker doSetTime msg ->
            let
                ( datePicker', datePickerCmd, mDate ) =
                    DatePicker.update msg model.datePicker

                commands =
                    datePickerFollowUp doSetTime mDate model
            in
                { model | datePicker = datePicker' }
                    ! List.append commands [ Cmd.map (ToDatePicker doSetTime) datePickerCmd ]



-- EFFECTS


setTime : Time -> Time -> Cmd Msg
setTime previousTime newTime =
    Task.perform identity (SetTime previousTime) (Task.succeed newTime)


datePickerFollowUp : Bool -> Maybe Date -> Model -> List (Cmd Msg)
datePickerFollowUp doSetTime mDate model =
    if doSetTime then
        case mDate of
            Nothing ->
                []

            Just date ->
                [ setTime model.time (Date.toTime date) ]
    else
        []



-- VIEW


view : Model -> Html Msg
view model =
    H.div []
        [ H.text (toString model.time)
        , H.span [ HE.onClick ToggleTimeOfDay ] [ H.text "Toggle" ]
        , Html.App.map (ToDatePicker True) (DatePicker.view model.datePicker)
        , Reading.view model.reading
        ]

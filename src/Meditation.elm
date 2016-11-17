module Meditation exposing (..)

import Time exposing (Time)
import Date exposing (Date)
import Task
import Html as H exposing (Html)
import Html.Events as HE
import Html.Attributes as HA
import Html.App
import Http
import DatePicker exposing (DatePicker)
import Reading exposing (Reading)
import Reading.Request
import ReadingTime
import FA


-- MODEL


type alias Model =
    { time : Time
    , reading : Reading
    , datePicker : DatePicker
    , isShowingTimeSelect : Bool
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
        , isShowingTimeSelect = False
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
    | AlertReadingLoadError Time Http.Error
    | ToDatePicker Bool DatePicker.Msg
    | ToggleTimeOfDay
    | ToggleTimeSelect


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime previousTime time ->
            ( { model | time = time }
            , Task.perform (AlertReadingLoadError previousTime) SetReading (Reading.Request.get time)
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

        ToggleTimeSelect ->
            ( { model | isShowingTimeSelect = not model.isShowingTimeSelect }
            , Cmd.none
            )



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
        [ H.div []
            [ H.span [ HE.onClick ToggleTimeSelect ]
                [ FA.fa "cog" (Just "cog")
                ]
            , H.div [ HA.class "time-select", HA.hidden (not model.isShowingTimeSelect) ]
                [ H.span [ HE.onClick ToggleTimeOfDay ]
                    [ timeOfDayToggle model.time
                    ]
                , Html.App.map (ToDatePicker True) (DatePicker.view model.datePicker)
                ]
            ]
        , H.div [ HA.class "time-increment", HE.onClick <| SetTime model.time (ReadingTime.increment model.time) ]
            [ FA.fa "chevron-right" (Just ">")
            ]
        , H.div [ HA.class "time-decrement", HE.onClick <| SetTime model.time (ReadingTime.decrement model.time) ]
            [ FA.fa "chevron-left" (Just "<")
            ]
        , Reading.view model.time model.reading
        ]


timeOfDayToggle : Time -> Html Msg
timeOfDayToggle time =
    case (ReadingTime.fromTime time |> .timeOfDay) of
        ReadingTime.Morning ->
            FA.fa "moon-o" (Just "moon")

        ReadingTime.Evening ->
            FA.fa "sun-o" (Just "sun")

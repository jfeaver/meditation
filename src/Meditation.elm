module Meditation exposing (..)

import Time exposing (Time)
import Date exposing (Date)
import Task
import Html as H exposing (Html)
import Html.Events as HE
import Html.Attributes as HA
import Html
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
        ( datePicker, datePickerCmd ) =
            DatePicker.init DatePicker.defaultSettings
    in
        { time = initTime
        , reading = Reading.none
        , datePicker = datePicker
        , isShowingTimeSelect = False
        }
            ! [ Task.perform (SetTime initTime) Time.now
              , Cmd.map (ToDatePicker True) datePickerCmd
              ]


initTime : Time
initTime =
    0



-- UPDATE


type Msg
    = SetTime Time Time
    | NewReading Time (Result Http.Error Reading)
    | ToDatePicker Bool DatePicker.Msg
    | ToggleTimeOfDay
    | ToggleTimeSelect


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime previousTime time ->
            ( { model | time = time }
            , Http.send (NewReading previousTime) (Reading.Request.get time)
            )

        NewReading _ (Ok reading) ->
            ( { model | reading = reading }
            , Cmd.none
            )

        NewReading previousTime (Err _) ->
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
                ( datePicker, datePickerCmd, mDate ) =
                    DatePicker.update msg model.datePicker

                commands =
                    datePickerFollowUp doSetTime mDate model
            in
                { model | datePicker = datePicker }
                    ! List.append commands [ Cmd.map (ToDatePicker doSetTime) datePickerCmd ]

        ToggleTimeSelect ->
            ( { model | isShowingTimeSelect = not model.isShowingTimeSelect }
            , Cmd.none
            )



-- EFFECTS


setTime : Time -> Time -> Cmd Msg
setTime previousTime newTime =
    Task.perform (SetTime previousTime) (Task.succeed newTime)


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
        [ H.div [ HA.class "tool" ]
            [ H.div [ HA.class "tool-action" ]
                [ H.span [ HE.onClick ToggleTimeSelect ]
                    [ FA.fa "cog"
                    ]
                ]
            , H.div [ HA.class "time-select-container", HA.hidden (not model.isShowingTimeSelect) ]
                [ H.div [ HA.class "time-select-nearby-selectors" ]
                    [ H.div [ HA.class "time-decrement", HE.onClick <| SetTime model.time (ReadingTime.decrement model.time) ]
                        [ FA.fa "chevron-left"
                        ]
                    , H.span [ HE.onClick ToggleTimeOfDay ]
                        [ timeOfDayToggle model.time
                        ]
                    , H.div [ HA.class "time-increment", HE.onClick <| SetTime model.time (ReadingTime.increment model.time) ]
                        [ FA.fa "chevron-right"
                        ]
                    ]
                , Html.map (ToDatePicker True) (DatePicker.view model.datePicker)
                ]
            ]
        , Reading.view model.time model.reading
        ]


timeOfDayToggle : Time -> Html Msg
timeOfDayToggle time =
    case (ReadingTime.fromTime time |> .timeOfDay) of
        ReadingTime.Morning ->
            FA.fa "sun-o"

        ReadingTime.Evening ->
            FA.fa "moon-o"

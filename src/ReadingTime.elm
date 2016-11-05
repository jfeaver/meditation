module ReadingTime
    exposing
        ( ReadingTime
        , Model
        , TimeOfDay(..)
        , Msg(..)
        , model
        , initCmd
        , update
        , toggleNode
        , navigation
        , selectTool
        , now
        , choose
        , toggle
        , increment
        , decrement
        , timeOfDay
        , month
        )

import Time exposing (Time)
import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions, defaultOptions)
import Json.Decode


type alias Model =
    { time : Time
    , readingTime : ReadingTime
    , showSelectTool : Bool
    }


type alias ReadingTime =
    { timeOfDay : TimeOfDay
    , month : Int
    , day : Int
    }


type TimeOfDay
    = Morning
    | Evening


model : Model
model =
    let
        time = 506502000000
    in
        { time = time
        , readingTime = fromTime' time
        , showSelectTool = False
        }


initCmd : Cmd Msg
initCmd =
    Task.perform Set Set now



-- UPDATE


type Msg
    = Set Model
    | Increment
    | Decrement
    | ToggleSelect
    | HideSelect


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Set model ->
            ( model, Cmd.none )

        Increment ->
            ( increment model
            , Cmd.none )

        Decrement ->
            ( decrement model
            , Cmd.none )

        ToggleSelect ->
            ( { model | showSelectTool = not model.showSelectTool }
            , Cmd.none )

        HideSelect ->
            ( { model | showSelectTool = False }
            , Cmd.none )



-- EFFECTS


now : Task x Model
now =
    Task.map (\time -> fromTime time model) Time.now



-- VIEW


toggleNode : Model -> Html Msg
toggleNode model =
    div [ class (toggleClass model) ]
        [ text "selectbox"
        , timeOfDayToggle model
        ]


navigation : Model -> Html Msg
navigation model =
    div []
        [ div [ class "nav-back", onClick Decrement ]
            [ text "<"
            ]
        , div [ class "nav-forward", onClick Increment ]
            [ text ">"
            ]
        ]


selectTool : Model -> Html Msg
selectTool model =
    i
        [ class "fa fa-calendar"
        , onWithOptions "click" { defaultOptions | stopPropagation = True } (Json.Decode.succeed ToggleSelect)
        ] [ text "calendar" ]



-- HELPERS


choose : ReadingTime -> a -> a -> a
choose readingTime morningThing eveningThing =
    case readingTime.timeOfDay of
        Morning ->
            morningThing

        Evening ->
            eveningThing


toggle : ReadingTime -> ReadingTime
toggle readingTime =
    { readingTime | timeOfDay = choose readingTime Evening Morning }


increment : Model -> Model
increment model =
    fromTime (model.time + 12 * Time.hour) model


decrement : Model -> Model
decrement model =
    fromTime (model.time - 12 * Time.hour) model


timeOfDay : ReadingTime -> String
timeOfDay readingTime =
    choose readingTime "Morning" "Evening"


month : ReadingTime -> String
month =
    .month >> Date.Extra.Core.intToMonth >> English.monthName



-- UNEXPOSED


timeOfDayToggle : Model -> Html Msg
timeOfDayToggle model =
    let
        setReadingTime =
            Set
                (
                    { model
                    | readingTime = toggle model.readingTime
                    }
                )
    in
        choose model.readingTime
            (img [ src "/assets/moon.png", onClick setReadingTime ] [])
            (img [ src "/assets/sun.png", onClick setReadingTime ] [])


toggleClass : Model -> String
toggleClass model =
    case model.showSelectTool of
        True ->
            "reading-time-select"

        False ->
            "reading-time-select hidden"


fromTime : Time -> Model -> Model
fromTime time model =
    { model
    | time = time
    , readingTime = fromTime' time
    }


fromTime' : Time -> ReadingTime
fromTime' time =
    let
        date =
            Date.fromTime time

        timeOfDay =
            if (Date.hour date) < 12 then
                Morning
            else
                Evening
    in
        { timeOfDay = timeOfDay
        , month = Date.Extra.Core.monthToInt (Date.month date)
        , day = Date.day date
        }


nextMorning : ReadingTime -> ReadingTime
nextMorning readingTime =
    readingTime

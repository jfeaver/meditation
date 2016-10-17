module ReadingTime
    exposing
        ( ReadingTime
        , Msg(..)
        , model
        , now
        , update
        , view
        , month
        )

import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)
import Html exposing (..)


type alias ReadingTime =
    { timeOfDay : TimeOfDay
    , month : Int
    , day : Int
    }


type TimeOfDay
    = Morning
    | Evening


model =
    { timeOfDay = Morning
    , month = 1
    , day = 19
    }


modelFromDate : Date -> ReadingTime
modelFromDate date =
    let
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


now : Task x Msg
now =
    Task.map (\date -> Update (modelFromDate date)) Date.now



-- UPDATE


type Msg
    = Update ReadingTime
    | ToggleMorningEvening


update : Msg -> ReadingTime -> ( ReadingTime, Cmd Msg )
update action readingTime =
    case action of
        Update newTime ->
            ( newTime, Cmd.none )

        ToggleMorningEvening ->
            ( { readingTime | timeOfDay = toggle readingTime }
            , Cmd.none
            )


toggle : ReadingTime -> TimeOfDay
toggle readingTime =
    case readingTime.timeOfDay of
        Morning ->
            Evening

        Evening ->
            Morning



-- VIEW


view : ReadingTime -> Html msg
view readingTime =
    text (title readingTime)


title : ReadingTime -> String
title readingTime =
    "Reading for: "
        ++ (timeOfDay readingTime)
        ++ ", "
        ++ (month readingTime)
        ++ " "
        ++ (toString readingTime.day)


timeOfDay : ReadingTime -> String
timeOfDay readingTime =
    case readingTime.timeOfDay of
        Morning ->
            "Morning"

        Evening ->
            "Evening"


month : ReadingTime -> String
month =
    .month >> Date.Extra.Core.intToMonth >> English.monthName

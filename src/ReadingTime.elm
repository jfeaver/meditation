module ReadingTime exposing
    ( ReadingTime
    , model
    , sync
    , toggleMorningEvening
    , view
    )


import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


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


sync : Task x ReadingTime
sync =
    Task.andThen Date.now doModelFromDate


doModelFromDate : Date -> Task x ReadingTime
doModelFromDate date =
    Task.succeed <| modelFromDate date



-- UPDATE



type Msg
    = ToggleMorningEvening


toggleMorningEvening : ReadingTime -> ReadingTime
toggleMorningEvening model =
    case model.timeOfDay of
        Morning ->
            { model | timeOfDay = Evening }

        Evening ->
            { model | timeOfDay = Morning }



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

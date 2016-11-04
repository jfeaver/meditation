module ReadingTime
    exposing
        ( ReadingTime
        , TimeOfDay(..)
        , model
        , now
        , choose
        , toggle
        , increment
        , decrement
        , timeOfDay
        , month
        , fromTime -- TODO: unexpose this
        )

import Time exposing (Time)
import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)


type alias ReadingTime =
    { time : Time
    , timeOfDay : TimeOfDay
    , month : Int
    , day : Int
    }


type TimeOfDay
    = Morning
    | Evening


model : ReadingTime
model =
    { time = 506502000000
    , timeOfDay = Morning
    , month = 1
    , day = 19
    }


now : Task x ReadingTime
now =
    Task.map (\time -> fromTime time) Time.now



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


increment : ReadingTime -> ReadingTime
increment readingTime =
    fromTime (readingTime.time + 12 * Time.hour)


decrement : ReadingTime -> ReadingTime
decrement readingTime =
    fromTime (readingTime.time - 12 * Time.hour)


timeOfDay : ReadingTime -> String
timeOfDay readingTime =
    choose readingTime "Morning" "Evening"


month : ReadingTime -> String
month =
    .month >> Date.Extra.Core.intToMonth >> English.monthName



-- UNEXPOSED


fromTime : Time -> ReadingTime
fromTime time =
    let
        date =
            Date.fromTime time

        timeOfDay =
            if (Date.hour date) < 12 then
                Morning
            else
                Evening
    in
        { time = time
        , timeOfDay = timeOfDay
        , month = Date.Extra.Core.monthToInt (Date.month date)
        , day = Date.day date
        }


nextMorning : ReadingTime -> ReadingTime
nextMorning readingTime =
    readingTime

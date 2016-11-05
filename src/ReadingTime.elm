module ReadingTime exposing (..)

import Time exposing (Time)
import Date
import Date.Extra.Core
import Task exposing (Task)
import TimeOfDay exposing (TimeOfDay)


type alias ReadingTime =
    { day : Int
    , month : Int
    , timeOfDay : TimeOfDay
    }


fromTime : Time -> ReadingTime
fromTime time =
    let
        date =
            Date.fromTime time

        timeOfDay =
            TimeOfDay.fromHour (Date.hour date)
    in
        { day = Date.day date
        , month = Date.Extra.Core.monthToInt (Date.month date)
        , timeOfDay = timeOfDay
        }


now : Task x ReadingTime
now =
    Task.map fromTime Time.now

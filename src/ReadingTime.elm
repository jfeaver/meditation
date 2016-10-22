module ReadingTime
    exposing
        ( ReadingTime
        , TimeOfDay(..)
        , model
        , fromDate
        , now
        , timeOfDay
        , month
        )

import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)


type alias ReadingTime =
    { timeOfDay : TimeOfDay
    , month : Int
    , day : Int
    }


type TimeOfDay
    = Morning
    | Evening


model : ReadingTime
model =
    { timeOfDay = Morning
    , month = 1
    , day = 19
    }


fromDate : Date -> ReadingTime
fromDate date =
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


now : Task x ReadingTime
now =
    Task.map (\date -> fromDate date) Date.now



-- VIEW


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

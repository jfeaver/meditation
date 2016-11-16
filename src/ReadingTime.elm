module ReadingTime exposing (..)

import Time exposing (Time)
import Date
import Date.Extra.I18n.I_en_us as English


type alias ReadingTime =
    { month : Date.Month
    , day : Int
    , timeOfDay : TimeOfDay
    }


type TimeOfDay
    = Morning
    | Evening


type alias TranslatedReadingTime =
    { month : String
    , day : String
    , timeOfDay : String
    }


increment : Time -> Time
increment time =
    time + 12 * Time.hour


decrement : Time -> Time
decrement time =
    time - 12 * Time.hour


toggle : Time -> Time
toggle time =
    case (timeOfDay time) of
        Morning ->
            increment time

        Evening ->
            decrement time


timeOfDay : Time -> TimeOfDay
timeOfDay time =
    if (Date.hour (Date.fromTime time)) < 12 then
        Morning
    else
        Evening


fromTime : Time -> ReadingTime
fromTime time =
    let
        date =
            Date.fromTime time
    in
        { month = Date.month date
        , day = Date.day date
        , timeOfDay = timeOfDay time
        }


translated : ReadingTime -> TranslatedReadingTime
translated readingTime =
    let
        tranlatedTimeOfDay =
            case readingTime.timeOfDay of
                Morning ->
                    "Morning"

                Evening ->
                    "Evening"
    in
        { month = English.monthName readingTime.month
        , day = toString readingTime.day
        , timeOfDay = tranlatedTimeOfDay
        }

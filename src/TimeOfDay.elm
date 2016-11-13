module TimeOfDay exposing (..)

import Time exposing (Time)
import Date


type TimeOfDay
    = Morning
    | Evening


toggle : Time -> Time
toggle time =
    case (timeOfDay time) of
        Morning ->
            time + 12 * Time.hour

        Evening ->
            time - 12 * Time.hour


timeOfDay : Time -> TimeOfDay
timeOfDay time =
    if (Date.hour (Date.fromTime time)) < 12 then
        Morning
    else
        Evening

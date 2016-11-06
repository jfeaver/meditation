module TimeOfDay exposing (..)


type TimeOfDay
    = Morning
    | Evening


fromHour : Int -> TimeOfDay
fromHour hour =
    if hour < 12 then
        Morning
    else
        Evening

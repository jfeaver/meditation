module EnglishReadingTime exposing (..)

import Time exposing (Time)
import Date exposing (Date)
import Date.Extra.I18n.I_en_us as English


month : Time -> String
month time =
    time
        |> Date.fromTime
        |> Date.month
        |> English.monthName


timeOfDay : Time -> String
timeOfDay time =
    let
        hour =
            time |> Date.fromTime |> Date.hour
    in
        if hour < 12 then
            "Morning"
        else
            "Evening"


day : Time -> String
day time =
    time |> Date.fromTime |> Date.day |> toString

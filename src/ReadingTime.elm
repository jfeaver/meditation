module ReadingTime exposing (..)

import Time exposing (Time)
import Task exposing (Task)


type alias ReadingTime =
    { time : Time
    }


fromTime : Time -> ReadingTime
fromTime time =
    { time = time
    }


now : Task x ReadingTime
now =
    Task.map fromTime Time.now

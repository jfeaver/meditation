module ReadingSelection exposing(ReadingSelection, init, forDate, timeOfDay, month, day)


import String
import Date exposing(Date)
import Task



-- TYPES


type alias ReadingSelection =
  { timeOfDay : TimeOfDay
  , date : SimpleDate
  }


type TimeOfDay
  = Morning
  | Evening


type alias SimpleDate =
  { month : Date.Month
  , day : Int
  }



-- METHODS


init : (Date -> a) -> (ReadingSelection, Cmd a)
init msg =
  ( ReadingSelection Morning (extractSimpleDate(Date.fromTime 506502000000)), (getCurrentTime msg))


forDate : Date -> ReadingSelection
forDate date =
  { date = extractSimpleDate date, timeOfDay = extractTimeOfDay date }


timeOfDay : ReadingSelection -> String
timeOfDay readingSelection =
  case readingSelection.timeOfDay of
    Morning -> "Morning"
    Evening -> "Evening"


month : ReadingSelection -> String
month readingSelection =
  case readingSelection.date.month of
    Date.Jan -> "January"
    Date.Feb -> "February"
    Date.Mar -> "March"
    Date.Apr -> "April"
    Date.May -> "May"
    Date.Jun -> "June"
    Date.Jul -> "July"
    Date.Aug -> "August"
    Date.Sep -> "September"
    Date.Oct -> "October"
    Date.Nov -> "November"
    Date.Dec -> "December"


day : ReadingSelection -> String
day readingSelection =
  toString readingSelection.date.day



-- PRIVATE METHODS


getCurrentTime : (Date -> a) -> Cmd a
getCurrentTime msg =
  Task.perform (\date -> msg date) (\date -> msg date) Date.now


extractSimpleDate : Date -> SimpleDate
extractSimpleDate date =
  { month = Date.month date
  , day = Date.day date
  }


extractTimeOfDay : Date -> TimeOfDay
extractTimeOfDay date =
  let
    hour = Date.hour date
  in
    if hour < 12 then
      Morning
    else
      Evening

port module Meditation exposing(..)


import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing(..)
import Html.Events exposing (onClick)
import String
import List
import Date exposing(Date)
import Task



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


getCurrentTime : Cmd Msg
getCurrentTime =
  Task.perform (\date -> ChangeDate date) (\date -> ChangeDate date) Date.now


init =
  ( Model Morning (extractSimpleDate(Date.fromTime 506502000000)), getCurrentTime)


-- MODEL


type alias Model =
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


{-
type alias Model =
  { month : String
  , day : Int
  , entry : Entry
  }


type alias Entry =
  { morning : Reading
  , evening : Reading
  }


type alias Reading =
  { verses : List Verse
  , reading : List String
  }


type alias Verse =
  { passage : String
  , reference : Reference
  }


type alias Reference =
  { book : String
  , chapter : Int
  , verse : Int
  }


model : Model
model =
  { month = "january"
  , day = 19
  , entry =
    { morning =
      { verses =
        [ { passage = "In the beginning..."
          , reference =
            { book = "genesis"
            , chapter = 1
            , verse = 1
            }
          }
        ]
      , reading =
        [ "Too early today?"
        ]
      }
    , evening =
      { verses =
        [ { passage = "In the beginning..."
          , reference =
            { book = "genesis"
            , chapter = 1
            , verse = 1
            }
          }
        ]
      , reading =
        [ "You've made it to the end of the day"
        ]
      }
    }
  }
-}



-- UPDATE


type Msg
  = Increment
  | Decrement
  | ToggleMorningEvening
  | ChangeDate Date


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      (model, Cmd.none)
    Decrement ->
      (model, Cmd.none)
    ToggleMorningEvening ->
      (model, Cmd.none)
    ChangeDate date ->
      ({ model | date = extractSimpleDate date, timeOfDay = extractTimeOfDay date }, Cmd.none)


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div
    [ class "container"
    ]
    [ div
      [ id "main"
      ]
      [ h2 [] [text ("Reading For " ++ (viewTimeOfDay model) ++ " of " ++ (viewMonth model) ++ " " ++ (viewDay model))]
      ]
    , div
      [ id "footer"
      ]
      []
    ]


viewTimeOfDay : Model -> String
viewTimeOfDay model =
  case model.timeOfDay of
    Morning -> "Morning"
    Evening -> "Evening"


viewMonth : Model -> String
viewMonth model =
  case model.date.month of
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


viewDay : Model -> String
viewDay model =
  toString model.date.day

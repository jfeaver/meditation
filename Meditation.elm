port module Meditation exposing(..)


import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing(..)
import Html.Events exposing (onClick)
import String
import List
import Date exposing(Date)
import Task
import ReadingSelection exposing(ReadingSelection)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


init =
  ReadingSelection.init ChangeDate


-- MODEL


type alias Model = ReadingSelection



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
      (ReadingSelection.forDate date, Cmd.none)



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
      [ h2 [] [text (viewReadingTitle model)]
      ]
    , div
      [ id "footer"
      ]
      []
    ]


viewReadingTitle : Model -> String
viewReadingTitle model =
  "Reading for: "
  ++ (ReadingSelection.timeOfDay model)
  ++ ", "
  ++ (ReadingSelection.month model)
  ++ " "
  ++ (ReadingSelection.day model)




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

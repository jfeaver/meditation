port module Meditation exposing(..)


import Html.App as Html
import Reading.Model exposing (Model)
import Reading.View
import Reading.Action exposing(Action(..))



main =
  Html.program
    { init = Reading.Model.init
    , view = Reading.View.view
    , update = update
    , subscriptions = subscriptions
    }



-- UPDATE


update : Action -> Model -> (Model, Cmd Action)
update msg model =
  case msg of
    Increment ->
      (model, Cmd.none)
    Decrement ->
      (model, Cmd.none)
    ToggleMorningEvening ->
      (model, Cmd.none)
    ChangeDate readingSelection ->
      (readingSelection, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
  Sub.none



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

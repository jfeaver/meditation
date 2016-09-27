port module Meditation exposing(..)


import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)
import String
import List



main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


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



-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg model =
  model



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]

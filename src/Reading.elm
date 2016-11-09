module Reading exposing (..)

import Time exposing (Time)
import EnglishReadingTime
import Http
import Html exposing (..)
import Html.Attributes exposing (..)



-- MODEL


type alias Model =
    { verses : List Verse
    , paragraphs : List String
    }


type alias Verse =
    { passage : String
    , reference : Reference
    }


type alias Reference =
    { book : String
    , chapter : String
    , verse : String
    }


model : Model
model =
    { verses = []
    , paragraphs = []
    }



-- UPDATE


type Msg
    = NewReadingTime Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewReadingTime time ->
            ( model, Cmd.none )


-- VIEW


view : Model -> Html Msg
view model =
    div [] []

module Meditation exposing (..)

import ReadingTime exposing (ReadingTime)
import EnglishReadingTime
import Html exposing (..)
import Html.Attributes exposing (..)
import Task


type alias Model =
    { readingTime : ReadingTime
    }


type Msg
    = SetReadingTime ReadingTime


model : Model
model =
    { readingTime = ReadingTime.fromTime 506502000000
    }


init : (Model, Cmd Msg)
init =
    (model, Task.perform SetReadingTime SetReadingTime ReadingTime.now)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetReadingTime readingTime ->
            ( { model | readingTime = readingTime }
            , Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text (EnglishReadingTime.month model.readingTime) ]

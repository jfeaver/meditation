module Meditation exposing (..)

import Time exposing (Time)
import EnglishReadingTime
import Html exposing (..)
import Html.Attributes exposing (..)
import Task


type alias Model =
    { time : Time
    }


type Msg
    = SetTime Time


model : Model
model =
    { time = 506502000000
    }


init : (Model, Cmd Msg)
init =
    (model, Task.perform SetTime SetTime Time.now)



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetTime time ->
            ( { model | time = time }
            , Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text (title model) ]


title : Model -> String
title model =
    List.foldr (++)
        ""
        [ "Reading for: "
        , EnglishReadingTime.timeOfDay model.time
        , ", "
        , EnglishReadingTime.month model.time
        , " "
        , EnglishReadingTime.day model.time
        ]


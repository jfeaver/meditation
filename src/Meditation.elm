module Meditation exposing (..)

import Time exposing (Time)
import EnglishReadingTime
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Task
import TimeSelect


type alias Model =
    { time : Time
    , timeSelect : TimeSelect.Model
    }


type Msg
    = SetTime Time
    | ToTimeSelect TimeSelect.Msg


init : (Model, Cmd Msg)
init =
    let
        ( timeSelect, timeSelectCmd ) =
            TimeSelect.init

    in
        { time = 506502000000
        , timeSelect = timeSelect
        }
        ! [ Cmd.map ToTimeSelect timeSelectCmd, Task.perform SetTime SetTime Time.now ]



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetTime time ->
            ( { model | time = time }
            , Cmd.none )

        ToTimeSelect timeSelectMsg ->
            let
                (timeSelect, timeSelectCmd) =
                    TimeSelect.update timeSelectMsg model.timeSelect

            in
                ( { model | timeSelect = timeSelect }
                , Cmd.map ToTimeSelect timeSelectCmd
                )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text (title model)
        , Html.App.map ToTimeSelect <| TimeSelect.view model.timeSelect
        ]


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


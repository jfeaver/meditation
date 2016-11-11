module Meditation exposing (..)

import Time exposing (Time)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Task
import TimeSelect
import Reading



-- MODEL


type alias Model =
    { time : Time
    , timeSelect : TimeSelect.Model
    , reading : Reading.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( timeSelect, timeSelectCmd ) =
            TimeSelect.init

    in
        { time = 506502000000
        , timeSelect = timeSelect
        , reading = Reading.model
        }
        ! [ Cmd.map ToTimeSelect timeSelectCmd ]



-- UPDATE


type Msg
    = SetTime Time
    | ToTimeSelect TimeSelect.Msg
    | DoNothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        SetTime time ->
            ( { model | time = time }
            , Cmd.none
            )

        ToTimeSelect timeSelectMsg ->
            let
                ( timeSelect, timeSelectCmd ) =
                    TimeSelect.update timeSelectMsg model.timeSelect

                succeedWithTime = Task.succeed timeSelect.time

            in
                { model | timeSelect = timeSelect }
                !
                [ Cmd.map ToTimeSelect timeSelectCmd
                , Task.perform SetTime SetTime succeedWithTime
                ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.App.map ToTimeSelect <| TimeSelect.view model.timeSelect
        , Reading.view DoNothing model.reading
        ]

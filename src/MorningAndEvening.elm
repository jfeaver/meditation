port module MorningAndEvening exposing (init, view, update, subscriptions)

import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { timeOfDay : TimeOfDay
    , month : Int
    , day : Int
    }


type TimeOfDay
    = Morning
    | Evening


model =
    { timeOfDay = Morning
    , month = 1
    , day = 19
    }


init : ( Model, Cmd Msg )
init =
    ( model, syncToday )


syncToday : Cmd Msg
syncToday =
    let
        success =
            (\model -> Update model)

        failure =
            (\model -> Update model)
    in
        Task.perform failure success getToday


getToday : Task Model Model
getToday =
    Task.andThen Date.now (\date -> Task.succeed (modelFromDate date))


modelFromDate : Date -> Model
modelFromDate date =
    let
        timeOfDay =
            if (Date.hour date) < 12 then
                Morning
            else
                Evening
    in
        { timeOfDay = timeOfDay
        , month = Date.Extra.Core.monthToInt (Date.month date)
        , day = Date.day date
        }



-- UPDATE


type Msg
    = Update Model
    | ToggleMorningEvening


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Update model ->
            ( model, Cmd.none )

        ToggleMorningEvening ->
            ( toggleMorningEvening model, Cmd.none )


toggleMorningEvening : Model -> Model
toggleMorningEvening model =
    case model.timeOfDay of
        Morning ->
            { model | timeOfDay = Evening }

        Evening ->
            { model | timeOfDay = Morning }



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
            [ h2 [] [ text (title model) ]
            , button [ onClick ToggleMorningEvening ] [ text "toggle" ]
            ]
        , div
            [ id "footer"
            ]
            []
        ]


title : Model -> String
title model =
    "Reading for: "
        ++ (timeOfDay model)
        ++ ", "
        ++ (month model)
        ++ " "
        ++ (toString model.day)


timeOfDay : Model -> String
timeOfDay model =
    case model.timeOfDay of
        Morning ->
            "Morning"

        Evening ->
            "Evening"


month : Model -> String
month =
    .month >> Date.Extra.Core.intToMonth >> English.monthName

port module Reading exposing ( init, view, update, subscriptions )


import Date exposing (Date)
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import String



-- MODEL


type alias Model =
    Date


initialModel =
    Date.fromTime 506502000000


init : ( Model, Cmd Action )
init =
    ( initialModel, (getCurrentDate ChangeDate) )


getCurrentDate : (Model -> a) -> Cmd a
getCurrentDate action =
    Task.perform (\date -> action date) (\date -> action date) Date.now



-- UPDATE


type Action
    = ChangeDate Model


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        ChangeDate model ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none



-- VIEW


type TimeOfDay
    = Morning
    | Evening


view : Model -> Html Action
view model =
    div
        [ class "container"
        ]
        [ div
            [ id "main"
            ]
            [ h2 [] [ text (title model) ]
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
        ++ (day model)


timeOfDay : Model -> String
timeOfDay model =
    case getTimeOfDay model of
        Morning ->
            "Morning"

        Evening ->
            "Evening"


getTimeOfDay : Model -> TimeOfDay
getTimeOfDay model =
    let
        hour =
            Date.hour model
    in
        if hour < 12 then
            Morning
        else
            Evening


month : Model -> String
month model =
    case Date.month model of
        Date.Jan ->
            "January"

        Date.Feb ->
            "February"

        Date.Mar ->
            "March"

        Date.Apr ->
            "April"

        Date.May ->
            "May"

        Date.Jun ->
            "June"

        Date.Jul ->
            "July"

        Date.Aug ->
            "August"

        Date.Sep ->
            "September"

        Date.Oct ->
            "October"

        Date.Nov ->
            "November"

        Date.Dec ->
            "December"


day : Model -> String
day model =
    model
        |> Date.day
        |> toString

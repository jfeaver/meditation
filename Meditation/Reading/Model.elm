module Reading.Model
    exposing
        ( Model
        , init
        )

import Date exposing (Date)
import Task


type alias Model =
    Date


initialModel =
    Date.fromTime 506502000000


init : (Model -> a) -> ( Model, Cmd a )
init action =
    ( initialModel, (getCurrentDate action) )


getCurrentDate : (Model -> a) -> Cmd a
getCurrentDate action =
    Task.perform (\date -> action date) (\date -> action date) Date.now

module Meditation exposing (..)

import Time exposing (Time)
import TimeSelect
import Reading exposing (Reading)
import Html exposing (Html)


-- MODEL


type Model
    = Model
        { time : Time
        , reading : Reading
        }


init : ( Model, Cmd Msg )
init =
    Debug.crash "Not Implemented"



-- UPDATE


type Msg
    = Never


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Debug.crash "Not Implemented"



-- VIEW


view : Model -> Html Msg
view mode =
    Debug.crash "Not Implemented"

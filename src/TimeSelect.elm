module TimeSelect exposing (..)

import Time exposing (Time)
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { datePicker : Int
    , time : Time
    }


type Msg
    = SetTime Time


model : Model
model =
    { datePicker = 0
    , time = 0
    }



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
    div [] []

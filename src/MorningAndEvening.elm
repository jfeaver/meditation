port module MorningAndEvening exposing (init, view, update, subscriptions)

import ReadingTime exposing (ReadingTime)
import Date exposing (Date)
import Date.Extra.Core
import Date.Extra.I18n.I_en_us as English
import Task exposing (Task)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { readingTime : ReadingTime
    }


model : Model
model =
    { readingTime = ReadingTime.model
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
    Task.andThen Date.now (\date -> Task.succeed ({ readingTime = ReadingTime.modelFromDate date }))



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
            ( { readingTime = ReadingTime.toggleMorningEvening model.readingTime }, Cmd.none )



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
            [ h2 [] [ ReadingTime.view model.readingTime ]
            , button [ onClick ToggleMorningEvening ] [ text "toggle" ]
            ]
        , div
            [ id "footer"
            ]
            []
        ]

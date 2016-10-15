port module MorningAndEvening exposing (init, view, update, subscriptions)

import ReadingTime exposing (ReadingTime)
import Date
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
    ( model, syncReading )


syncReading : Cmd Msg
syncReading =
    let
        success =
            (\readingTime -> UpdateReadingTime readingTime)

        failure =
            (\readingTime -> UpdateReadingTime readingTime)
    in
        Task.perform failure success ReadingTime.now



-- UPDATE


type Msg
    = UpdateReadingTime ReadingTime
    | ToggleMorningEvening


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        UpdateReadingTime readingTime ->
            ( { model | readingTime = readingTime }, Cmd.none )

        ToggleMorningEvening ->
            ( { model | readingTime = ReadingTime.toggleMorningEvening model.readingTime }, Cmd.none )



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

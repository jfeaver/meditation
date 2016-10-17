port module MorningAndEvening exposing (init, view, update, subscriptions)

import ReadingTime exposing (ReadingTime)
import Reading exposing (Reading)
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { readingTime : ReadingTime
    , reading: Maybe Reading
    }


model : Model
model =
    { readingTime = ReadingTime.model
    , reading = Nothing
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
    = UpdateReadingTime ReadingTime.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        UpdateReadingTime readingMsg ->
            let
                ( newTime, fx ) =
                    ReadingTime.update readingMsg model.readingTime
            in
                ( { model | readingTime = newTime }
                , Cmd.map UpdateReadingTime fx
                )



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
            , button [ onClick (UpdateReadingTime ReadingTime.ToggleMorningEvening) ] [ text "toggle" ]
            , p [] [ text (Reading.url model.readingTime) ]
            ]
        , div
            [ id "footer"
            ]
            []
        ]

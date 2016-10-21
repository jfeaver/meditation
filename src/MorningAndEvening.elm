port module MorningAndEvening exposing (init, view, update, subscriptions)

import Reading exposing (Reading)
import ReadingTime exposing (ReadingTime)
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { readingTime : ReadingTime
    , reading : Reading
    }


model : Model
model =
    { readingTime = ReadingTime.model
    , reading = Reading.model
    }


init : ( Model, Cmd Msg )
init =
    ( model,  Cmd.none)


{-
initReading : Cmd Msg
initReading =
    Task.perform updateReading updateReading Reading.init
-}



-- UPDATE


type Msg
    = UpdateReading


{-
updateReading : Reading -> Msg -> Reading
updateReading reading =
    UpdateReading reading
-}

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        UpdateReading ->
            ( model, Cmd.none )
            {-
            let
                ( newTime, fx ) =
                    ReadingTime.update readingMsg model.readingTime
            in
                ( { model | readingTime = newTime }
                , Cmd.map UpdateReadingTime fx
                )
            -}



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
            [ text "content" ]
            {-
            [ h2 [] [ ReadingTime.view model.readingTime ]
            , button [ onClick (UpdateReading Reading.ToggleMorningEvening) ] [ text "toggle" ]
            , Reading.view Reading.model
            ]
            -}
        , div
            [ id "footer"
            ]
            []
        ]

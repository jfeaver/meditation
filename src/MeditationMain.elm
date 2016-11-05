port module MeditationMain exposing (main)

import Html.App
import Meditation


main =
    Html.App.program
        { init = Meditation.init
        , update = Meditation.update
        , subscriptions = always Sub.none
        , view = Meditation.view
        }

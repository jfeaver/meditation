port module MeditationMain exposing (main)

import Html
import Meditation


main =
    Html.program
        { init = Meditation.init
        , update = Meditation.update
        , subscriptions = always Sub.none
        , view = Meditation.view
        }

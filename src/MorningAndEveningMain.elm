port module MorningAndEveningMain exposing (main)

import Html.App as Html
import MorningAndEvening


main =
    Html.program
        { init = MorningAndEvening.init
        , view = MorningAndEvening.view
        , update = MorningAndEvening.update
        , subscriptions = MorningAndEvening.subscriptions
        }

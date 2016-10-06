port module ReadingMain exposing (main)

import Html.App as Html
import Reading


main =
    Html.program
        { init = Reading.init
        , view = Reading.view
        , update = Reading.update
        , subscriptions = Reading.subscriptions
        }

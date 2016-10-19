module Verse
    exposing
        ( Verse
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Verse =
    { passage : String
    , reference:
        { book: String
        , chapter: Int
        , verse: Int
        }
    }



-- VIEW


view : Verse -> Html msg
view verse =
    blockquote
        []
        [ p [] [ text verse.passage ]
        , p
            [ class "citation"
            ]
            [ text "—"
            , text verse.reference.book
            , text " "
            , verse.reference.chapter |> toString |> text
            , text ":"
            , verse.reference.verse |> toString |> text
            ]
        ]

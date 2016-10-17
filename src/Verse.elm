module Verse
    exposing
        ( Verse
        )


type alias Verse =
    { passage : String
    , reference:
        { book: String
        , chapter: Int
        , verse: Int
        }
    }

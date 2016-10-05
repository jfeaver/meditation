module Reading.Model exposing
  ( Model
  , init
  )


import Date exposing(Date)



type alias Model = Date


initialModel =
  Date.fromTime 506502000000


init =
  (initialModel, Cmd.none)

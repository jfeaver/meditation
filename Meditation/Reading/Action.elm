module Reading.Action exposing (Action(..))


import Reading.Model exposing (Model)



type Action
  = Increment
  | Decrement
  | ToggleMorningEvening
  | ChangeDate Model

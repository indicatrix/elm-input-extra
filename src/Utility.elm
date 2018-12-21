module Utility exposing (KeyCode, join, showBool)


join : Maybe (Maybe a) -> Maybe a
join mx =
    case mx of
        Just x ->
            x

        Nothing ->
            Nothing


type alias KeyCode =
    Int


showBool : Bool -> String
showBool b =
    if b then
        "True"

    else
        "False"

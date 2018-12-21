module Utility exposing (KeyCode, join)


join : Maybe (Maybe a) -> Maybe a
join mx =
    case mx of
        Just x ->
            x

        Nothing ->
            Nothing


type alias KeyCode =
    Int

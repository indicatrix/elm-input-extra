module Utility exposing (KeyCode, join, showBool, showMaybeFloat, showMaybeInt)


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


showMaybeInt : Maybe Int -> String
showMaybeInt i =
    case i of
        Just s ->
            String.fromInt s

        Nothing ->
            ""


showMaybeFloat : Maybe Float -> String
showMaybeFloat f =
    case f of
        Just s ->
            String.fromFloat s

        Nothing ->
            ""

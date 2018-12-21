module Input.Text exposing (input, Options, defaultOptions)

{-| Text input


# View

@docs input, Options, defaultOptions

-}

import Char exposing (fromCode)
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes exposing (id, type_, value)
import Html.Events exposing (custom, keyCode, onBlur, onFocus, onInput)
import Input.Decoder exposing (eventDecoder)
import Input.KeyCode exposing (allowedKeyCodes)
import Json.Decode as Json
import String


{-| Options of the input component.

  - `maxLength` is the maximum number of character allowed in this input. Set to `Nothing` for no limit.
  - `onInput` is the Msg tagger for the onInput event.
  - `hasFocus` is an optional Msg tagger for onFocus/onBlur event.
  - `type_` is the type of the HTML input element.

-}
type alias Options msg =
    { maxLength : Maybe Int
    , onInput : String -> msg
    , hasFocus : Maybe (Bool -> msg)
    , type_ : String
    }


{-| Default value for `Options`.

  - `onInput` (type: `String -> msg`) : The onInput Msg tagger

Value:

    { maxLength = Nothing
    , onInput = onInput
    , hasFocus = Nothing
    , type_ = "text"
    }

-}
defaultOptions : (String -> msg) -> Options msg
defaultOptions onInput =
    { maxLength = Nothing
    , onInput = onInput
    , hasFocus = Nothing
    , type_ = "text"
    }


{-| Text input element

Example:

    type Msg = InputUpdated String | FocusUpdated Bool

    Input.Text.input
        { maxLength = 10
        , onInput = InputUpdated
        , hasFocus = Just FocusUpdated
        }
        [ class "textInput"
        ...
        ]
        model.currentValue

-}
input : Options msg -> List (Attribute msg) -> String -> Html msg
input options attributes currentValue =
    let
        onFocusAttribute =
            options.hasFocus
                |> Maybe.map (\f -> f True)
                |> Maybe.map onFocus
                |> Maybe.map (\a -> (::) a [])
                |> Maybe.withDefault []

        onBlurAttribute =
            options.hasFocus
                |> Maybe.map (\f -> f False)
                |> Maybe.map onBlur
                |> Maybe.map (\a -> (::) a [])
                |> Maybe.withDefault []
    in
    Html.input
        (List.append attributes
            [ value currentValue
            , onKeyDown options currentValue options.onInput
            , onInput options.onInput
            , type_ options.type_
            ]
            |> List.append onFocusAttribute
            |> List.append onBlurAttribute
        )
        []


onKeyDown : Options msg -> String -> (String -> msg) -> Attribute msg
onKeyDown options currentValue tagger =
    let
        filterKey =
            \event ->
                let
                    newValue =
                        currentValue ++ (event.keyCode |> Char.fromCode |> String.fromChar)
                in
                if event.ctrlKey || event.altKey then
                    Json.fail "modifier key is pressed"

                else if List.any ((==) event.keyCode) allowedKeyCodes then
                    Json.fail "not arrow"

                else if isValid newValue options then
                    Json.fail "valid"

                else
                    Json.succeed event.keyCode

        decoder =
            eventDecoder
                |> Json.andThen filterKey
                |> Json.map (\_ -> { stopPropagation = False, preventDefault = True, message = tagger currentValue })
    in
    custom "keydown" decoder


isValid : String -> Options msg -> Bool
isValid value options =
    let
        exceedMaxLength =
            options.maxLength
                |> Maybe.map ((<=) (String.length value))
                |> Maybe.map not
                |> Maybe.withDefault False
    in
    not exceedMaxLength

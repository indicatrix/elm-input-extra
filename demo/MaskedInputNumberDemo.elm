module MaskedInputNumberDemo exposing (main)

import Browser
import Html exposing (Html, form, label, li, p, text, ul)
import Html.Attributes as Html exposing (for, style)
import MaskedInput.Number as MaskedNumber
import Utility


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { value : Maybe Int
    , state : MaskedNumber.State
    , hasFocus : Bool
    }


init : Model
init =
    { value = Nothing, hasFocus = False, state = MaskedNumber.initialState }


inputOptions : MaskedNumber.Options Msg
inputOptions =
    let
        defaultOptions =
            MaskedNumber.defaultOptions InputChanged InputStateChanged
    in
    { defaultOptions
        | pattern = "(###) ###-####"
        , hasFocus = Just FocusChanged
    }


view : Model -> Html Msg
view model =
    form []
        [ p []
            [ label []
                [ text "Masked Input: "
                , MaskedNumber.input
                    inputOptions
                    [ Html.classList [ ( "focused", model.hasFocus ) ] ]
                    model.state
                    model.value
                ]
            ]
        , p []
            [ ul []
                [ li [] [ text "Pattern: ", text inputOptions.pattern ]
                , li [] [ text "Value: ", text <| Utility.showMaybeInt model.value ]
                , li [] [ text "Has Focus: ", text <| Utility.showBool model.hasFocus ]
                ]
            ]
        ]


type Msg
    = NoOp
    | InputChanged (Maybe Int)
    | FocusChanged Bool
    | InputStateChanged MaskedNumber.State


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        InputChanged value ->
            { model | value = value }

        FocusChanged bool ->
            { model | hasFocus = bool }

        InputStateChanged state ->
            { model | state = state }

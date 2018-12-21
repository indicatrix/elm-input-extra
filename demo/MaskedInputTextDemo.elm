module MaskedInputTextDemo exposing (main)

import Browser
import Html exposing (Html, form, label, li, p, text, ul)
import Html.Attributes as Html exposing (for, style)
import MaskedInput.Text as MaskedText


main : Program Never Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { value : String
    , state : MaskedText.State
    , hasFocus : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { value = "", hasFocus = False, state = MaskedText.initialState }
    , Cmd.none
    )


inputOptions : MaskedText.Options Msg
inputOptions =
    let
        defaultOptions =
            MaskedText.defaultOptions InputChanged InputStateChanged
    in
    { defaultOptions
        | pattern = "(###) ###-####"
        , hasFocus = Just FocusChanged
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    form []
        [ p []
            [ label []
                [ text "Masked Input: "
                , MaskedText.input
                    inputOptions
                    [ Html.classList [ ( "focused", model.hasFocus ) ] ]
                    model.state
                    model.value
                ]
            ]
        , p []
            [ ul []
                [ li [] [ text "Pattern: ", text inputOptions.pattern ]
                , li [] [ text "Value: ", text model.value ]
                , li [] [ text "Has Focus: ", text <| showBool model.hasFocus ]
                ]
            ]
        ]


showBool : Bool -> String
showBool b =
    if b then
        "True"

    else
        "False"


type Msg
    = NoOp
    | InputChanged String
    | FocusChanged Bool
    | InputStateChanged MaskedText.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InputChanged value ->
            ( { model | value = value }, Cmd.none )

        FocusChanged bool ->
            ( { model | hasFocus = bool }, Cmd.none )

        InputStateChanged state ->
            ( { model | state = state }, Cmd.none )

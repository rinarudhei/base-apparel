module Main exposing (..)

import Browser
import Element exposing (Element, rgb255)
import Element.Background
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)



---- DESIGN SYSTEM ----


white : Element.Color
white =
    rgb255 255 255 255


black : Element.Color
black =
    rgb255 0 0 0


red : Element.Color
red =
    rgb255 249 100 100


pink : Element.Color
pink =
    rgb255 206 152 152


gradient1 : { angle : Float, steps : List Element.Color }
gradient1 =
    { angle = -1.466, steps = [ rgb255 248 191 191, rgb255 238 139 139 ] }


gradient2 : { angle : Float, steps : List Element.Color }
gradient2 =
    { angle = -1.3788, steps = [ white, rgb255 255 244 244 ] }


gradient3 : { angle : Float, steps : List Element.Color }
gradient3 =
    { angle = 1.44862, steps = [ rgb255 255 244 244, white ] }



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

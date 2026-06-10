module Main exposing (..)

import Browser
import Element exposing (Element, column, el, px, rgb255, text)
import Element.Font as Font
import Element.Region as Region exposing (heading)
import Html exposing (Html)
import Html.Attributes exposing (src)



---- DESIGN SYSTEM ----
-- COLORS


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



-- TYPHOGRAPHY


josefin : Element.Attribute msg
josefin =
    Font.family
        [ Font.typeface "Josefin Sans"
        , Font.sansSerif
        ]



-- SPACING


spacing0 : Element.Length
spacing0 =
    px 0


spacing100 : Element.Length
spacing100 =
    px 8


spacing200 : Element.Length
spacing200 =
    px 16


spacing300 : Element.Length
spacing300 =
    px 24


spacing400 : Element.Length
spacing400 =
    px 32


spacing500 : Element.Length
spacing500 =
    px 40


spacing800 : Element.Length
spacing800 =
    px 64


spacing1000 : Element.Length
spacing1000 =
    px 80


spacing1100 : Element.Length
spacing1100 =
    px 88


spacing1700 : Element.Length
spacing1700 =
    px 136



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
    Element.layout [ josefin, Font.semiBold ] (column [] [ myTitle ])


myTitle : Element.Element msg
myTitle =
    el [ Region.heading 1 ] (text "HELLO BASE APPAREL")



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

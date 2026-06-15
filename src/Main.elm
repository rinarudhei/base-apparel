module Main exposing (..)

import Browser
import Browser.Events
import Element
    exposing
        ( Device
        , DeviceClass(..)
        , Element
        , Orientation(..)
        , alignLeft
        , alignRight
        , alpha
        , centerX
        , centerY
        , classifyDevice
        , column
        , el
        , fill
        , height
        , htmlAttribute
        , image
        , inFront
        , maximum
        , moveLeft
        , moveRight
        , moveUp
        , paddingEach
        , paddingXY
        , paragraph
        , px
        , rgb255
        , rgba
        , rgba255
        , row
        , scrollbarY
        , shrink
        , spaceEvenly
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input
import Element.Region as Region
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)
import Platform.Cmd as Cmd
import Regex



---- DESIGN SYSTEM ----
-- COLORS


transparentColor : Element.Color
transparentColor =
    rgba 0 0 0 0


white : Element.Color
white =
    rgb255 255 255 255


black : Element.Color
black =
    rgb255 0 0 0


gray : Element.Color
gray =
    rgb255 66 58 58


red : Element.Color
red =
    rgb255 249 100 100


pink : Element.Color
pink =
    rgb255 206 152 152


pinkAlpha : Float -> Element.Color
pinkAlpha opacity =
    rgba255 206 152 152 opacity


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


textPreset1Light : List (Element.Attribute msg)
textPreset1Light =
    [ Font.light
    , Font.size 64
    , Font.letterSpacing 17.4
    ]


textPreset1SemiBold : List (Element.Attribute msg)
textPreset1SemiBold =
    [ Font.semiBold
    , Font.size 64
    , Font.letterSpacing 17.4
    ]


textPreset2Light : List (Element.Attribute msg)
textPreset2Light =
    [ Font.light
    , Font.size 40
    , Font.letterSpacing 10
    ]


textPreset2SemiBold : List (Element.Attribute msg)
textPreset2SemiBold =
    [ Font.semiBold
    , Font.size 40
    , Font.letterSpacing 10
    ]


textPreset3 : List (Element.Attribute msg)
textPreset3 =
    [ Font.regular
    , Font.size 16
    , htmlAttribute (style "line-height" "2.15")

    -- line-height 215%`
    ]


textPreset4 : List (Element.Attribute msg)
textPreset4 =
    [ Font.regular
    , Font.size 14
    , htmlAttribute (style "line-height" "1.55")

    -- line-height 155%`
    ]


textPreset5 : List (Element.Attribute msg)
textPreset5 =
    [ Font.regular
    , Font.size 13
    , htmlAttribute (style "line-height" "2.15")

    -- line-height 215%`
    ]



---- UTILS ----


fontClamp : String -> Element.Attribute msg
fontClamp clampValue =
    Element.htmlAttribute (style "font-size" clampValue)


paddingBottom : Int -> Element.Attribute msg
paddingBottom bottomPadding =
    paddingEach { top = 0, right = 0, bottom = bottomPadding, left = 0 }


paddingTop : Int -> Element.Attribute msg
paddingTop topPadding =
    paddingEach { bottom = 0, right = 0, top = topPadding, left = 0 }


paddingRight : Int -> Element.Attribute msg
paddingRight rightPadding =
    paddingEach { bottom = 0, top = 0, right = rightPadding, left = 0 }


paddingLeft : Int -> Element.Attribute msg
paddingLeft leftPadding =
    paddingEach { bottom = 0, top = 0, left = leftPadding, right = 0 }


paddingLR : Int -> Int -> Element.Attribute msg
paddingLR leftPadding rightPadding =
    paddingEach { bottom = 0, top = 0, left = leftPadding, right = rightPadding }



---- MODEL ----


type alias Flags =
    { width : Int
    , height : Int
    }


type alias Model =
    { device : Device
    , email : String
    , emailError : Maybe String
    }


type Layout
    = LayoutBigScreen
    | LayoutSmallScreen


layoutSelector : Device -> Layout
layoutSelector device =
    case device.class of
        Phone ->
            LayoutSmallScreen

        Tablet ->
            LayoutSmallScreen

        _ ->
            LayoutBigScreen


validateEmail : String -> Bool
validateEmail email =
    let
        pattern =
            Maybe.withDefault Regex.never <|
                Regex.fromString "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    in
    Regex.contains pattern email


deviceToString : Device -> String
deviceToString device =
    case device.class of
        Phone ->
            "Phone"

        Tablet ->
            "Tablet"

        Desktop ->
            "Desktop"

        BigDesktop ->
            "Big Desktop"


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { device =
            classifyDevice
                { width = flags.width
                , height = flags.height
                }
      , email = ""
      , emailError = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = WindowResized Int Int
    | UpdateEmail String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResized w h ->
            ( { model | device = classifyDevice { height = h, width = w } }, Cmd.none )

        UpdateEmail newEmail ->
            let
                error =
                    if newEmail == "" then
                        Just "Email is required"

                    else if not (validateEmail newEmail) then
                        Just "Please provide a valid email"

                    else
                        Nothing
            in
            ( { model | email = newEmail, emailError = error }
            , Cmd.none
            )



---- VIEW ----


emailInput : Model -> Element.Element Msg
emailInput model =
    case model.device.class of
        Phone ->
            column [ spacing 8, width fill ]
                [ el
                    [ inFront (submitButton model)
                    , inFront (errorIcon model)
                    , width fill
                    , height (px 48)
                    , Border.color pink
                    , Border.rounded 28
                    , Border.width 1
                    , centerY
                    ]
                    (textInput model)
                , emailErrorText model.emailError
                ]

        _ ->
            column [ spacing 8, width fill ]
                [ el
                    [ inFront (submitButton model)
                    , inFront (errorIcon model)
                    , width fill
                    , height (px 56)
                    , Border.color pink
                    , Border.rounded 28
                    , Border.width 1
                    , centerY
                    ]
                    (textInput model)
                , emailErrorText model.emailError
                ]


textInputResponsiveStyle : Device -> List (Element.Attribute msg)
textInputResponsiveStyle device =
    case device.class of
        Phone ->
            [ paddingXY 24 16
            ]

        _ ->
            [ paddingXY 32 20
            ]


textInput : Model -> Element.Element Msg
textInput model =
    column
        [ width fill
        , height fill
        ]
        [ Input.email
            ([ Background.color transparentColor
             , htmlAttribute (Html.Attributes.id "email-input")
             , Font.alignLeft
             , Border.width 0
             , Font.color gray
             ]
                ++ textInputResponsiveStyle model.device
                ++ textPreset3
            )
            { onChange = UpdateEmail
            , text = model.email
            , placeholder =
                Just
                    (Input.placeholder
                        (textPreset3
                            ++ [ centerY, Font.color (pinkAlpha 0.5), height fill ]
                        )
                        (text "Email Address")
                    )
            , label = Input.labelHidden "email-input"
            }
        ]


submitButtonResponsiveStyle : Device -> List (Element.Attribute msg)
submitButtonResponsiveStyle device =
    case device.class of
        Phone ->
            [ height (px 48)
            , width (px 64)
            ]

        _ ->
            [ height (px 56)
            , width (px 100)
            ]


submitButton : Model -> Element.Element msg
submitButton model =
    Input.button
        ([ alignRight
         , centerY
         , Background.gradient gradient1
         , Border.color (rgb255 206 152 152)
         , Border.rounded 28
         , moveUp 1
         , moveRight 1
         , Border.shadow { offset = ( 0, 15 ), blur = 20, color = rgba255 198 110 110 0.24, size = 1 }
         ]
            ++ submitButtonResponsiveStyle model.device
        )
        { label =
            row
                [ centerX
                , centerY
                ]
                [ image
                    [ width fill, height fill ]
                    { description = "right arrow", src = "images/icon-arrow.svg" }
                ]
        , onPress = Nothing
        }


errorIconResponsiveStyle : Device -> List (Element.Attribute msg)
errorIconResponsiveStyle device =
    case device.class of
        Phone ->
            [ moveLeft 70 ]

        _ ->
            [ moveLeft 116 ]


errorIcon : Model -> Element.Element msg
errorIcon model =
    case model.emailError of
        Nothing ->
            Element.none

        _ ->
            column ([ alignRight, centerY ] ++ errorIconResponsiveStyle model.device)
                [ el
                    [ width (px 24)
                    , height (px 24)
                    ]
                    (image
                        [ width fill, height fill ]
                        { description = "input error icon", src = "images/icon-error.svg" }
                    )
                ]


emailErrorText : Maybe String -> Element.Element msg
emailErrorText emailError =
    case emailError of
        Nothing ->
            Element.none

        Just err ->
            column [ paddingLeft 26, height (px 28) ] [ el (textPreset5 ++ [ Font.color red, centerY ]) (text err) ]


content : Model -> Element.Element Msg
content model =
    case model.device.class of
        Phone ->
            column
                [ height shrink
                , width (px 312)
                , centerX
                , paddingEach { top = 64, bottom = 32, left = 0, right = 0 }
                ]
                [ column [ Region.heading 1, centerX, center, width fill, paddingEach { top = 0, right = 0, bottom = 16, left = 0 } ]
                    [ el (textPreset2Light ++ [ Font.color pink, center, centerX, height (px 42) ]) (text "WE'RE")
                    , paragraph ([ Font.color gray, center ] ++ textPreset2SemiBold) [ text "COMING SOON" ]
                    ]
                , paragraph
                    ([ Font.color pink, center, paddingEach { top = 0, right = 0, bottom = 32, left = 0 } ] ++ textPreset4)
                    [ text "Hello fellow shoppers! We're currently building our new fashion store. Add your email below to stay up-to-date with announcements and our launch deals." ]
                , emailInput model
                ]

        Tablet ->
            column
                [ height shrink
                , width (px 445)
                , centerX
                , paddingEach { top = 64, bottom = 64, left = 0, right = 0 }
                ]
                [ column [ Region.heading 1, centerX, center, width fill, paddingEach { top = 0, right = 0, bottom = 32, left = 0 } ]
                    [ el (textPreset1Light ++ [ Font.color pink, center, centerX, height (px 64) ]) (text "WE'RE")
                    , paragraph ([ Font.color gray, center ] ++ textPreset1SemiBold) [ text "COMING SOON" ]
                    ]
                , paragraph
                    ([ Font.color pink, center, paddingEach { top = 0, right = 0, bottom = 32, left = 0 } ] ++ textPreset3)
                    [ text "Hello fellow shoppers! We're currently building our new fashion store. Add your email below to stay up-to-date with announcements and our launch deals." ]
                , emailInput model
                ]

        _ ->
            column
                [ height shrink
                , width (px 400)
                , paddingEach { top = 136, bottom = 138, left = 0, right = 0 }
                ]
                [ column [ Region.heading 1, centerX, center, width fill, paddingEach { top = 0, right = 0, bottom = 32, left = 0 } ]
                    [ el (textPreset1Light ++ [ Font.color pink, height (px 64) ]) (text "WE'RE")
                    , paragraph ([ Font.color gray, Font.alignLeft, height (px 132) ] ++ textPreset1SemiBold) [ text "COMING SOON" ]
                    ]
                , paragraph
                    ([ Font.color pink, Font.alignLeft, paddingEach { top = 0, right = 0, bottom = 32, left = 0 } ] ++ textPreset3)
                    [ text "Hello fellow shoppers! We're currently building our new fashion store. Add your email below to stay up-to-date with announcements and our launch deals." ]
                , emailInput model
                ]


backgroundMask : Element msg
backgroundMask =
    image
        [ width fill
        , height (px 800)
        ]
        { description = "Desktop background pattern", src = "images/bg-pattern-desktop.svg" }


heroImage : Device -> Element.Element msg
heroImage device =
    let
        description =
            "hero image"
    in
    case device.class of
        Phone ->
            image
                [ width fill
                , height shrink
                ]
                { description = description, src = "images/hero-mobile.jpg" }

        Tablet ->
            image
                [ width (fill |> maximum 769)
                , height shrink
                , centerX
                ]
                { description = description, src = "images/hero-tablet.jpg" }

        Desktop ->
            image
                [ width (fill |> maximum 610)
                , height (fill |> maximum 800)
                ]
                { description = description, src = "images/hero-desktop.jpg" }

        BigDesktop ->
            image
                [ width (fill |> maximum 610)
                , height (fill |> maximum 800)
                ]
                { description = description, src = "images/hero-desktop.jpg" }


logoImage : Device -> Element.Element msg
logoImage device =
    let
        description =
            "logo image"

        src =
            "images/logo.svg"
    in
    case device.class of
        Phone ->
            image
                [ height (px 19)
                , paddingEach { left = 32, right = 0, top = 32, bottom = 32 }
                , alignLeft
                ]
                { description = description, src = src }

        Tablet ->
            image
                [ height (px 19)
                , paddingEach { left = 80, right = 80, top = 32, bottom = 64 }
                , alignLeft
                ]
                { description = description, src = src }

        _ ->
            image
                [ height (px 31)
                , width (px 157)
                , paddingTop 80
                ]
                { description = description, src = src }


pageLayout : Model -> Element.Element Msg
pageLayout model =
    case layoutSelector model.device of
        LayoutSmallScreen ->
            column [ width fill, height shrink ]
                [ logoImage model.device
                , heroImage model.device
                , content model
                ]

        LayoutBigScreen ->
            row
                [ width fill
                , height fill
                , spaceEvenly
                ]
                [ el
                    [ height (fill |> maximum 800)
                    , width fill
                    , inFront
                        (column
                            [ width fill
                            , height fill
                            , htmlAttribute (style "padding-left" "165px")
                            ]
                            [ logoImage model.device
                            , content model
                            ]
                        )
                    ]
                    backgroundMask
                , heroImage model.device
                ]


view : Model -> Html Msg
view model =
    Element.layout
        [ josefin
        , scrollbarY
        , Background.gradient gradient2
        ]
        (pageLayout model)



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize (\w h -> WindowResized w h)



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = \flags -> init flags
        , update = update
        , subscriptions = subscriptions
        }

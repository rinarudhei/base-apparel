module Tests exposing (..)

import Element exposing (Device, DeviceClass(..), Orientation(..))
import Expect
import Html exposing (div, img, text)
import Html.Attributes exposing (src)
import Main exposing (Model, Msg(..), emailConfig, update, view)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


initialModel : Model
initialModel =
    { device = { class = Phone, orientation = Portrait }
    , email = ""
    , emailError = Nothing
    }


testUpdate : Test
testUpdate =
    describe "update"
        [ describe "WindowResized"
            [ test "window resized to Desktop" <|
                \_ ->
                    update (WindowResized 1300 800) initialModel
                        |> Tuple.first
                        |> Expect.equal { initialModel | device = { class = Desktop, orientation = Landscape } }
            , test "window resized to Tablet" <|
                \_ ->
                    update (WindowResized 600 800) initialModel
                        |> Tuple.first
                        |> Expect.equal { initialModel | device = { class = Tablet, orientation = Portrait } }
            , test "window resized to Phone" <|
                \_ ->
                    update (WindowResized 360 480) initialModel
                        |> Tuple.first
                        |> Expect.equal { initialModel | device = { class = Phone, orientation = Portrait } }
            , test "window resized to BigDesktop" <|
                \_ ->
                    update (WindowResized 2000 1200) initialModel
                        |> Tuple.first
                        |> Expect.equal { initialModel | device = { class = BigDesktop, orientation = Landscape } }
            ]
        , describe "UpdateEmail"
            [ test "update email with valid email" <|
                \_ ->
                    update (UpdateEmail "unittest@mail.com") initialModel
                        |> Tuple.first
                        |> Expect.equal { initialModel | email = "unittest@mail.com", emailError = Nothing }
            , test "update email with invalid email" <|
                \_ ->
                    update (UpdateEmail "unittest!invalid.com") initialModel
                        |> Tuple.first
                        |> Expect.equal { initialModel | email = "unittest!invalid.com", emailError = Just emailConfig.invalidMessage }
            , test "update email with empty string" <|
                \_ ->
                    update (UpdateEmail "typesomething") initialModel
                        |> Tuple.first
                        |> update (UpdateEmail "")
                        |> Tuple.first
                        |> Expect.equal { initialModel | email = "", emailError = Just emailConfig.requiredMessage }
            ]
        ]


emailErrorModel : Model
emailErrorModel =
    { device = { class = Phone, orientation = Portrait }
    , email = "invalid!email"
    , emailError = Just emailConfig.invalidMessage
    }


testView : Test
testView =
    describe "view"
        [ test "initial page" <|
            \_ ->
                view initialModel
                    |> Query.fromHtml
                    |> Query.find [ Selector.tag "label" ]
                    |> Query.contains [ text "Email Address" ]
        , test "invalid email" <|
            \_ ->
                Expect.all
                    [ \v ->
                        v
                            |> Query.contains [ text emailConfig.invalidMessage ]
                    , \v ->
                        v
                            |> Query.has [ Selector.tag "img", Selector.attribute (Html.Attributes.alt "input error icon") ]
                    ]
                    (view emailErrorModel |> Query.fromHtml)
        ]

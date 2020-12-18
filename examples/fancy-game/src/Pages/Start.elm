module Pages.Start exposing (Flags, Model, Msg, page)

import Fancy
import Html exposing (Html, div, text)
import Shared exposing (Shared)



-- Setup


type alias Flags =
    ()


type alias Model =
    { value : String }


init : Flags -> Shared -> ( Model, Shared, Cmd Msg )
init flags session =
    ( { value = "Start" }, session, Cmd.none )



-- Update


type Msg
    = UpdateValue String


title : Model -> Shared -> String
title model shared =
    model.value


update : Msg -> Model -> Shared -> ( Model, Shared, Cmd Msg )
update msg model shared =
    case msg of
        UpdateValue value ->
            ( { model | value = value }, shared, Cmd.none )


subscriptions : Model -> Shared -> Sub Msg
subscriptions model session =
    Sub.none



-- View


view : Model -> Shared -> Html Msg
view model session =
    div [] [ text model.value ]



-- Fancy.Page
-- Useful for using Fancy helpers


page : Fancy.Page Flags Shared Model Msg
page =
    { title = title
    , init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

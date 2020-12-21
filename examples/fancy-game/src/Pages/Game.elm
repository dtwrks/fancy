module Pages.Game exposing (Flags, Model, Msg, page)

import Fancy
import Html exposing (Html, div, text)
import Shared exposing (Shared)



-- Setup


type alias Flags =
    ()


type alias Model =
    String


init : Flags -> Shared -> ( Model, Shared, Cmd Msg )
init _ session =
    ( "Game", session, Cmd.none )



-- Update


type Msg
    = UpdateValue String


title : Model -> Shared -> String
title model _ =
    model


update : Msg -> Model -> Shared -> ( Model, Shared, Cmd Msg )
update msg _ shared =
    case msg of
        UpdateValue value ->
            ( value, shared, Cmd.none )


subscriptions : Model -> Shared -> Sub Msg
subscriptions _ _ =
    Sub.none



-- View


view : Model -> Shared -> Html Msg
view model _ =
    div [] [ text model ]



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

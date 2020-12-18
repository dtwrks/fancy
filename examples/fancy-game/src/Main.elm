module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Fancy
import Layouts.Main exposing (layout)
import Pages.Game
import Pages.GameMenu
import Pages.Start
import Shared exposing (Shared)
import Url exposing (Url)



-- Setup


type alias Model =
    Fancy.App Shared Page


type Page
    = Start Pages.Start.Model
    | GameMenu Pages.GameMenu.Model
    | Game Pages.Game.Model


type Msg
    = OnUrlRequest Browser.UrlRequest
    | OnUrlChange Url
    | StartMsg Pages.Start.Msg
    | GameMsg Pages.Game.Msg
    | GameMenuMsg Pages.GameMenu.Msg


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ navKey =
    Fancy.initPage
        { config = Pages.Start.config
        , flags = ()
        , session = Session.init navKey
        , msgTagger = StartMsg
        , modelTagger = Start
        }



-- Update


router : Url -> Model -> ( Model, Cmd Msg )
router url model =
    case Url.toString url of
        "/" ->
            Fancy.initPage
                { config = Pages.Start.config
                , flags = ()
                , session = model.session
                , msgTagger = StartMsg
                , modelTagger = Start
                }

        "/menu" ->
            Fancy.initPage
                { config = Pages.Game.config
                , flags = ()
                , session = model.session
                , msgTagger = GameMsg
                , modelTagger = Game
                }

        "/game" ->
            Fancy.initPage
                { config = Pages.GameMenu.config
                , flags = ()
                , session = model.session
                , msgTagger = GameMenuMsg
                , modelTagger = GameMenu
                }

        _ ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        -- Page: All
        ( OnUrlRequest urlRequest, _ ) ->
            Fancy.onUrlRequest model.session.navKey model urlRequest

        ( OnUrlChange url, _ ) ->
            router url model

        -- Page: Start
        ( StartMsg pageMsg, Start pageModel ) ->
            Fancy.updatePage
                { config = Pages.Start.config
                , msg = pageMsg
                , page = pageModel
                , session = model.session
                , msgTagger = StartMsg
                , modelTagger = Start
                }

        ( StartMsg _, _ ) ->
            ( model, Cmd.none )

        -- Page: GameMenu
        ( GameMenuMsg pageMsg, GameMenu pageModel ) ->
            Fancy.updatePage
                { config = Pages.GameMenu.config
                , msg = pageMsg
                , page = pageModel
                , session = model.session
                , msgTagger = GameMenuMsg
                , modelTagger = GameMenu
                }

        ( GameMenuMsg _, _ ) ->
            ( model, Cmd.none )

        -- Page: Game
        ( GameMsg pageMsg, Game pageModel ) ->
            Fancy.updatePage
                { config = Pages.Game.config
                , msg = pageMsg
                , page = pageModel
                , session = model.session
                , msgTagger = GameMsg
                , modelTagger = Game
                }

        ( GameMsg _, _ ) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        Start pageModel ->
            Fancy.subscribePage
                { config = Pages.Start.config
                , page = pageModel
                , session = model.session
                , msgTagger = StartMsg
                }

        Game pageModel ->
            Fancy.subscribePage
                { config = Pages.Game.config
                , page = pageModel
                , session = model.session
                , msgTagger = GameMsg
                }

        GameMenu pageModel ->
            Fancy.subscribePage
                { config = Pages.GameMenu.config
                , page = pageModel
                , session = model.session
                , msgTagger = GameMenuMsg
                }



-- View


view : Model -> Browser.Document Msg
view model =
    let
        page =
            case model.page of
                Start pageModel ->
                    Fancy.viewPage
                        { config = Pages.Start.page
                        , page = pageModel
                        , session = model.session
                        , msgTagger = StartMsg
                        }

                Game pageModel ->
                    Fancy.viewPage
                        { config = Pages.Game.page
                        , page = pageModel
                        , session = model.session
                        , msgTagger = GameMsg
                        }

                GameMenu pageModel ->
                    Fancy.viewPage
                        { config = Pages.GameMenu.page
                        , page = pageModel
                        , session = model.session
                        , msgTagger = GameMenuMsg
                        }
    in
    layout page



-- Main


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }

module Fancy exposing
    ( App
    , Page
    , Widget
    , initPage
    , onUrlRequest
    , subNothing
    , subscribePage
    , updateNothing
    , updatePage
    , viewNothing
    , viewPage
    )

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (Html, text)
import Url exposing (Url)



-- App


type alias App session page =
    { session : session
    , page : page
    }



-- Page


type alias Page flags session model msg =
    { title : model -> session -> String
    , init : flags -> session -> ( model, session, Cmd msg )
    , update : msg -> model -> session -> ( model, session, Cmd msg )
    , subscriptions : model -> session -> Sub msg
    , view : model -> session -> Html msg
    }


liftToApp :
    (msg -> appMsg)
    -> (model -> appModel)
    -> ( model, session, Cmd msg )
    -> ( App session appModel, Cmd appMsg )
liftToApp msgTagger modelTagger ( model, session, cmd ) =
    ( { page = modelTagger model
      , session = session
      }
    , Cmd.map msgTagger cmd
    )


initPage :
    { config : Page flags session model msg
    , flags : flags
    , session : session
    , msgTagger : msg -> appMsg
    , modelTagger : model -> appModel
    }
    -> ( App session appModel, Cmd appMsg )
initPage { config, flags, session, msgTagger, modelTagger } =
    config.init flags session
        |> liftToApp msgTagger modelTagger


updatePage :
    { config : Page flags session model msg
    , msg : msg
    , session : session
    , page : model
    , msgTagger : msg -> appMsg
    , modelTagger : model -> appModel
    }
    -> ( App session appModel, Cmd appMsg )
updatePage { config, msg, session, page, msgTagger, modelTagger } =
    config.update msg page session
        |> liftToApp msgTagger modelTagger


subscribePage :
    { config : Page flags session model msg
    , page : model
    , session : session
    , msgTagger : msg -> appMsg
    }
    -> Sub appMsg
subscribePage { config, page, session, msgTagger } =
    config.subscriptions page session
        |> Sub.map msgTagger


viewPage :
    { config : Page flags session model msg
    , page : model
    , session : session
    , msgTagger : msg -> appMsg
    }
    -> Browser.Document appMsg
viewPage { config, page, session, msgTagger } =
    { title = config.title page session
    , body =
        config.view page session
            |> Html.map msgTagger
            |> List.singleton
    }



-- Widget - In Progress
-- Haven't figured out a way to remove boilerplate from widgets in a useful way
-- They should be able to be used directly on routers and not just on pages (layout widgets)


type alias Widget flags shared model msg =
    { init : flags -> shared -> ( model, shared, Cmd msg )
    , update : msg -> model -> shared -> ( model, shared, Cmd msg )
    , subscriptions : model -> shared -> Sub msg
    , view : model -> shared -> Html msg
    }


liftToPage :
    (msg -> pageMsg)
    -> (model -> pageModel)
    -> ( model, shared, Cmd msg )
    -> ( pageModel, shared, Cmd pageMsg )
liftToPage msgTagger modelTagger ( model, shared, msg ) =
    ( modelTagger model, shared, Cmd.map msgTagger msg )


initWidget :
    { config : Widget flags shared model msg
    , flags : flags
    , shared : shared
    , msgTagger : msg -> pageMsg
    , modelTagger : model -> pageModel
    }
    -> ( pageModel, shared, Cmd pageMsg )
initWidget { config, flags, shared, msgTagger, modelTagger } =
    config.init flags shared
        |> liftToPage msgTagger modelTagger


updateWidget :
    { config : Page flags shared model msg
    , msg : msg
    , shared : shared
    , widget : model
    , msgTagger : msg -> pageMsg
    , modelTagger : model -> pageModel
    }
    -> ( pageModel, shared, Cmd pageMsg )
updateWidget { config, msg, shared, widget, msgTagger, modelTagger } =
    config.update msg widget shared
        |> liftToPage msgTagger modelTagger


subscribeWidget :
    { config : Page flags session model msg
    , widget : model
    , session : session
    , msgTagger : msg -> pageMsg
    }
    -> Sub pageMsg
subscribeWidget { config, widget, session, msgTagger } =
    config.subscriptions widget session
        |> Sub.map msgTagger


viewWidget :
    { config : Widget flags shared model msg
    , widget : model
    , shared : shared
    , msgTagger : msg -> pageMsg
    }
    -> Html pageMsg
viewWidget { config, widget, shared, msgTagger } =
    config.view widget shared
        |> Html.map msgTagger



-- Page: Helpers


onUrlRequest : Nav.Key -> model -> UrlRequest -> ( model, Cmd msg )
onUrlRequest navKey model urlRequest =
    case urlRequest of
        External url ->
            ( model, Nav.load url )

        Internal url ->
            ( model, Nav.pushUrl navKey <| Url.toString url )


updateNothing : msg -> model -> session -> ( model, session, Cmd msg )
updateNothing _ model session =
    ( model, session, Cmd.none )


subNothing : model -> session -> Sub msg
subNothing _ _ =
    Sub.none


viewNothing : model -> session -> Html msg
viewNothing _ _ =
    text ""

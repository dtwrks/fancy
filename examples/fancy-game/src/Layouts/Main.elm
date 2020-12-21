module Layouts.Main exposing (layout)

import Browser
import Html exposing (div)


layout : Browser.Document msg -> Browser.Document msg
layout view =
    { title = view.title
    , body = [ div [] view.body ]
    }

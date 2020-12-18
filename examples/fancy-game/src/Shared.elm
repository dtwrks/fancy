module Shared exposing (Shared, init)

import Browser.Navigation as Nav


type alias Shared =
    { navKey : Nav.Key
    , username : String
    , topScore : Int
    }


init : Nav.Key -> Shared
init navKey =
    { navKey = navKey
    , username = ""
    , topScore = 0
    }

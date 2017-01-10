module Model exposing (..)

import Set exposing (empty)


type alias Model =
    { drinks : List Drink
    , locations : Set.Set String
    , locationSearch : String
    , alertMessage : Maybe String
    }


type alias Drink =
    { id : Int
    , name : String
    , broadCategory : String
    , detailedCategory : String
    , origin : String
    , alcoholContent : Int
    , description : String
    , tastingNote : String
    , imgThumb : String
    , img : String
    , varietal : String
    , style : String
    }


initialModel : Model
initialModel =
    { drinks = []
    , locations = Set.empty
    , locationSearch = ""
    , alertMessage = Nothing
    }

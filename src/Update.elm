module Update exposing (..)

import Model exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Set exposing (..)


-- UPDATE


type Msg
    = UpdateDrinks (Result Http.Error (List Drink))
    | LocationSearch String


getLocations : List Drink -> Set.Set String
getLocations drinks =
    drinks
        |> List.map (\drink -> drink.origin)
        |> Set.fromList


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateDrinks result ->
            case result of
                Ok drinks ->
                    ( { model | drinks = drinks, locations = getLocations drinks }, Cmd.none )

                Err error ->
                    ( { model | alertMessage = Just (toString error) }, Cmd.none )

        LocationSearch search ->
            ( { model | locationSearch = search }, Cmd.none )



-- COMMANDS


drinksUrl : String
drinksUrl =
    "https://gist.githubusercontent.com/mmckeaveney/61800fcdfb6596f7c2c5d853b1b03e34/raw/afa4986bbdd830965ea3cb70b5b94832a255e172/DrinksAPI.json"


getDrinks : Cmd Msg
getDrinks =
    Decode.list (drinkDecoder)
        |> Http.get drinksUrl
        |> Http.send UpdateDrinks



-- DECODERS


drinkDecoder : Decoder Drink
drinkDecoder =
    decode Drink
        |> required "id" int
        |> required "name" string
        |> optional "primary_category" string ("")
        |> optional "secondary_category" string ("")
        |> optional "origin" string ("")
        |> optional "alcohol_content" int (0)
        |> optional "description" string ("")
        |> optional "tasting_note" string ("")
        |> optional "image_thumb_url" string ("")
        |> optional "image_url" string ("")
        |> optional "varietal" string ("")
        |> optional "style" string ("")

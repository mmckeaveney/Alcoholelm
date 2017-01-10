module View exposing (..)

import Model exposing (..)
import Update exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Regex exposing (regex, contains, caseInsensitive)
import Set exposing (..)


buildRegex : String -> (String -> Bool)
buildRegex searchInput =
    searchInput
        |> Regex.regex
        |> Regex.caseInsensitive
        |> Regex.contains


renderLocations : String -> Set.Set String -> List (Html Msg)
renderLocations searchInput locations =
    locations
        |> Set.toList
        |> List.filter (buildRegex searchInput)
        |> List.map (\location -> li [ class "location", onClick (LocationSearch location) ] [ text location ])


renderDrinks : String -> List Drink -> List (Html Msg)
renderDrinks location drinks =
    let
        regex =
            location |> buildRegex
    in
        drinks
            |> List.filter (\drink -> (regex drink.origin))
            |> List.map
                (\drink ->
                    li [ class "drink" ]
                        [ h4 [] [ text drink.name ]
                        , h5 [] [ text drink.broadCategory ]
                        , h5 [] [ text drink.detailedCategory ]
                        , img [ src drink.imgThumb ] []
                        , p [] [ text drink.description ]
                        , p [] [ text drink.origin ]
                        , p [] [ text drink.style ]
                        , p [] [ text drink.tastingNote ]
                        , p [] [ text drink.varietal ]
                        , p [] [ text (toString drink.alcoholContent) ]
                        ]
                )


viewAlertMessage : Maybe String -> Html Msg
viewAlertMessage alertMessage =
    case alertMessage of
        Just message ->
            div [ class "alert" ]
                [ span [ class "close", onClick CloseAlert ] [ text "X" ]
                , text message
                ]

        Nothing ->
            text ""


appView : Model -> Html Msg
appView model =
    div [ class "app-container" ]
        [ h1 [ class "title" ] [ text "Elmcohol Alcohol Database" ]
        , viewAlertMessage model.alertMessage
        , h2 [ class "current-search" ] [ text model.locationSearch ]
        , div [ class "search" ] [ input [ class "search__bar", placeholder "Type in a location to see the drinks..", onInput LocationSearch ] [] ]
        , ul [ class "locations" ] (renderLocations model.locationSearch model.locations)
        , ul [ class "drinks" ] (renderDrinks model.locationSearch model.drinks)
        ]

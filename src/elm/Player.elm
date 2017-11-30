module Player exposing (playerTable, fetchPlayers, addFavPlayer)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), User, initModel, decodePlayer)
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Http
import Dict
import Json.Decode as Decode


playerTable : Bool -> List Player -> Html Msg
playerTable bool players =
    table [] <| List.append [ playerHeaders bool ] <| List.map (playerRow bool) players


playerHeaders : Bool -> Html Msg
playerHeaders bool =
    tr []
        [ th [] [ text "First Name" ]
        , th [] [ text "Last Name" ]
        , th [] [ text "Position" ]
        , th [] [ text "Jersey Number" ]
        , th [] [ text "salary" ]
        , th [] [ text "Team Name" ]
        , if bool then
            th [] [ text "Add" ]
          else
            th [] [ text "Delete" ]
        ]


playerRow : Bool -> Player -> Html Msg
playerRow bool p =
    tr []
        [ td [] [ text p.firstName ]
        , td [] [ text p.lastName ]
        , td [] [ text p.position ]
        , td [] [ text <| toString p.jerseyNumber ]
        , td [] [ text <| toString p.salary ]
        , td [] [ text p.teamName ]
        , if bool then
            td [] [ Button.button [ Button.success, Button.onClick (AddPlayer p) ] [ text "Add" ] ]
          else
            td [] [ Button.button [ Button.danger, Button.onClick (DeletePlayer p) ] [ text "Delete" ] ]
        ]


processPlayer : Result Http.Error (List Player) -> Msg
processPlayer result =
    case result of
        Ok players ->
            HandlePlayers players

        Err err ->
            HandleError err


fetchPlayers : Dict.Dict String String -> Cmd Msg
fetchPlayers dict =
    let
        ( query, searchType ) =
            getPQuery dict

        temp =
            Debug.log "typeQ:" searchType
    in
        case searchType of
            "all" ->
                Http.send processPlayer <| Http.get "http://localhost:3000/getAllPlayers" (Decode.list decodePlayer)

            "firstName" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/" ++ query.fN ++ "/" ++ query.lN) (Decode.list decodePlayer)

            "lastName" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/" ++ query.fN ++ "/" ++ query.lN) (Decode.list decodePlayer)

            "firstName lastName" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/" ++ query.fN ++ "/" ++ query.lN) (Decode.list decodePlayer)

            "firstName lastName teamName" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/" ++ query.fN ++ "/" ++ query.lN ++ "/" ++ query.tN) (Decode.list decodePlayer)

            "firstName lastName teamName position" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/" ++ query.fN ++ "/" ++ query.lN ++ "/" ++ query.tN ++ "/" ++ query.p) (Decode.list decodePlayer)

            "position" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/" ++ query.p) (Decode.list decodePlayer)

            "teamName position" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/tp/" ++ query.tN ++ "/" ++ query.p) (Decode.list decodePlayer)

            "firstName lastName position" ->
                Http.send processPlayer <| Http.get ("http://localhost:3000/getPlayers/flp/" ++ query.fN ++ "/" ++ query.lN ++ "/" ++ query.p) (Decode.list decodePlayer)

            _ ->
                Http.send processPlayer <| Http.get "http://localhost:3000/getAllPlayers" (Decode.list decodePlayer)


addFavPlayer : String -> Int -> User -> Cmd Msg
addFavPlayer typeof id user =
    case typeof of
        "add" ->
            Http.send processFavPlayer <| Http.get ("http://localhost:3000/favPlayer/add/" ++ (toString id) ++ "/" ++ user.username) Decode.bool

        "delete" ->
            Http.send processFavPlayer <| Http.get ("http://localhost:3000/favPlayer/delete/" ++ (toString id) ++ "/" ++ user.username) Decode.bool

        _ ->
            Http.send processFavPlayer <| Http.get ("http://localhost:3000/favPlayer/add/" ++ (toString id) ++ "/" ++ user.username) Decode.bool


processFavPlayer : Result Http.Error Bool -> Msg
processFavPlayer result =
    case result of
        Ok players ->
            HandleFav players

        Err err ->
            HandleError err


type alias BasicPQ =
    { fN : String
    , lN : String
    , tN : String
    , p : String
    }


getPQuery : Dict.Dict String String -> ( BasicPQ, String )
getPQuery dict =
    let
        f =
            Maybe.withDefault "nothing" <| Dict.get "firstName" dict

        l =
            Maybe.withDefault "nothing" <| Dict.get "lastName" dict

        t =
            Maybe.withDefault "nothing" <| Dict.get "teamName" dict

        p =
            Maybe.withDefault "nothing" <| Dict.get "position" dict

        list =
            [ ( "firstName", f )
            , ( "lastName", l )
            , ( "teamName", t )
            , ( "position", p )
            ]

        temp =
            Debug.log "list" list

        typeOf =
            if List.length (Dict.toList dict) < 1 then
                "all"
            else
                String.concat <| List.intersperse " " <| List.map Tuple.first <| List.filter (\( x, y ) -> y /= "nothing") list
    in
        ( BasicPQ f l t p, typeOf )

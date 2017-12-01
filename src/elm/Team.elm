module Team exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), User, decodeTeam, initModel)
import Json.Decode as Decode
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Http
import Dict


teamTable : Bool -> List Team -> Html Msg
teamTable bool teams =
    table [] <| List.append [ teamHeaders bool ] <| List.map (teamRow bool) teams


teamHeaders : Bool -> Html Msg
teamHeaders bool =
    tr []
        [ th [] [ text "Name" ]
        , th [] [ text "League" ]
        , th [] [ text "City" ]
        , th [] [ text "Year Founded" ]
        , th [] [ text "Coach Name" ]
        , th [] [ text "Wins" ]
        , th [] [ text "Losses" ]
        , th [] [ text "Ties" ]
        , if bool then
            th [] [ text "Add" ]
          else
            th [] [ text "Delete" ]
        ]


teamRow : Bool -> Team -> Html Msg
teamRow bool t =
    tr []
        [ td [] [ text t.name ]
        , td [] [ text t.league ]
        , td [] [ text t.city ]
        , td [] [ text <| toString t.yearFounded ]
        , td [] [ text t.coachName ]
        , td [] [ text <| toString t.wins ]
        , td [] [ text <| toString t.losses ]
        , td [] [ text <| toString t.ties ]
        , if bool then
            td [] [ Button.button [ Button.success, Button.onClick (AddTeam t) ] [ text "Add" ] ]
          else
            td [] [ Button.button [ Button.danger, Button.onClick (DeleteTeam t) ] [ text "Delete" ] ]
        ]


addFavTeam : String -> Int -> User -> Cmd Msg
addFavTeam typeof id user =
    case typeof of
        "add" ->
            Http.send processFavTeam <| Http.get ("http://localhost:3000/favTeam/add/" ++ (toString id) ++ "/" ++ user.username) Decode.bool

        "delete" ->
            Http.send processFavTeam <| Http.get ("http://localhost:3000/favTeam/delete/" ++ (toString id) ++ "/" ++ user.username) Decode.bool

        _ ->
            Http.send processFavTeam <| Http.get ("http://localhost:3000/favTeam/add/" ++ (toString id) ++ "/" ++ user.username) Decode.bool


processFavTeam : Result Http.Error Bool -> Msg
processFavTeam result =
    case result of
        Ok players ->
            HandleFav players

        Err err ->
            HandleError err


processTeam : Result Http.Error (List Team) -> Msg
processTeam result =
    case result of
        Ok teams ->
            HandleTeams teams

        Err err ->
            HandleError err


fetchTeams : Dict.Dict String String -> Cmd Msg
fetchTeams dict =
    let
        ( query, searchType ) =
            getTQuery dict
    in
        case searchType of
            "all" ->
                Http.send processTeam <| Http.get "http://localhost:3000/getAllTeams" (Decode.list decodeTeam)

            "teamName" ->
                Http.send processTeam <| Http.get ("http://localhost:3000/getTeams/byName/?tName=" ++ query.name) (Decode.list decodeTeam)

            "teamName league" ->
                Http.send processTeam <| Http.get ("http://localhost:3000/getTeams/byTeamLeague/?tName=" ++ query.name ++ "&league=" ++ query.league) (Decode.list decodeTeam)

            "league" ->
                Http.send processTeam <| Http.get ("http://localhost:3000/getTeams/byLeague/?league=" ++ query.league) (Decode.list decodeTeam)

            _ ->
                Http.send processTeam <| Http.get "http://localhost:3000/getAllTeams" (Decode.list decodeTeam)


type alias BasicTQ =
    { name : String
    , league : String
    }


getTQuery : Dict.Dict String String -> ( BasicTQ, String )
getTQuery dict =
    let
        cleanDict =
            Dict.fromList <| List.filter (\( x, y ) -> not <| String.isEmpty y) <| Dict.toList dict

        t =
            Maybe.withDefault "nothing" <| Dict.get "teamName" cleanDict

        l =
            Maybe.withDefault "nothing" <| Dict.get "league" cleanDict

        list =
            [ ( "teamName", t )
            , ( "league", l )
            ]

        temp =
            Debug.log "list" list

        typeOf =
            if List.length (Dict.toList cleanDict) < 1 then
                "all"
            else
                String.concat <| List.intersperse " " <| List.map Tuple.first <| List.filter (\( x, y ) -> y /= "nothing") list
    in
        ( BasicTQ t l, typeOf )

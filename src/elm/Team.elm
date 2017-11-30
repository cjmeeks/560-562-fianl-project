module Team exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), decodeTeam, initModel, listOfQueryParams)
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


processTeam : Result Http.Error (List Team) -> Msg
processTeam result =
    case result of
        Ok teams ->
            HandleTeams teams

        Err err ->
            HandleError err


fetchTeams : String -> Dict.Dict String String -> Cmd Msg
fetchTeams searchType dict =
    case searchType of
        "all" ->
            Http.send processTeam <| Http.get "http://localhost:3000/getAllTeams" (Decode.list decodeTeam)

        _ ->
            Http.send processTeam <| Http.get "http://localhost:3000/getAllTeams" (Decode.list decodeTeam)

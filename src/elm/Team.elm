module Team exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), initModel, listOfQueryParams)
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button


teamTable : List Team -> Html Msg
teamTable teams =
    table [] <| List.append [ teamHeaders ] <| List.map teamRow teams


teamHeaders : Html Msg
teamHeaders =
    tr []
        [ th [] [ text "Name" ]
        , th [] [ text "League" ]
        , th [] [ text "City" ]
        , th [] [ text "Year Founded" ]
        , th [] [ text "Coach Name" ]
        , th [] [ text "Wins" ]
        , th [] [ text "Losses" ]
        , th [] [ text "Ties" ]
        , th [] [ text "Add" ]
        ]


teamRow : Team -> Html Msg
teamRow t =
    tr []
        [ td [] [ text t.name ]
        , td [] [ text t.league ]
        , td [] [ text t.city ]
        , td [] [ text <| toString t.yearFounded ]
        , td [] [ text t.coachName ]
        , td [] [ text <| toString t.wins ]
        , td [] [ text <| toString t.losses ]
        , td [] [ text <| toString t.ties ]
        , td [] [ Button.button [ Button.success, Button.onClick (AddTeam t) ] [ text "Add" ] ]
        ]

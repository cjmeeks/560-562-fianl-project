module Player exposing (playerTable)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), initModel, listOfQueryParams)
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button


playerTable : List Player -> Html Msg
playerTable players =
    table [] <| List.append [ playerHeaders ] <| List.map playerRow players


playerHeaders : Html Msg
playerHeaders =
    tr []
        [ th [] [ text "First Name" ]
        , th [] [ text "Last Name" ]
        , th [] [ text "Position" ]
        , th [] [ text "Jersey Number" ]
        , th [] [ text "salary" ]
        , th [] [ text "Team Name" ]
        ]


playerRow : Player -> Html Msg
playerRow p =
    tr []
        [ td [] [ text p.firstName ]
        , td [] [ text p.lastName ]
        , td [] [ text p.position ]
        , td [] [ text <| toString p.jerseyNumber ]
        , td [] [ text <| toString p.salary ]
        , td [] [ text p.teamName ]
        ]

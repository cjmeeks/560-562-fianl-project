module Player exposing (playerTable)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, SearchType(..), initModel, listOfQueryParams)
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button


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

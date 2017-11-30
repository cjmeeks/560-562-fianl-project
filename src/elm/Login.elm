module Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, User, SearchType(..), initModel)
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as Group
import Bootstrap.Button as Button
import Json.Decode as Decode
import Http


loginView : Html Msg
loginView =
    div [ class "login-container" ]
        [ Group.config (Group.text [ Input.attrs [ onInput Username ] ])
            |> Group.predecessors
                [ Group.span [] [ text "Username" ] ]
            |> Group.view
        , Group.config (Group.password [ Input.attrs [ onInput Password ] ])
            |> Group.predecessors
                [ Group.span [] [ text "Password" ] ]
            |> Group.view
        , Button.button
            [ Button.success
            , Button.onClick LoginButton
            ]
            [ text "Login" ]
        ]


loginCall : User -> Cmd Msg
loginCall user =
    Http.send processUser <| Http.get ("http://localhost:3000/login/?username=" ++ user.username ++ "&pass=" ++ user.password) Decode.bool


processUser : Result Http.Error Bool -> Msg
processUser result =
    case result of
        Ok bool ->
            HandleUser bool

        Err err ->
            HandleError err

module Signup exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Msg(..), Model, Player, Team, User, SearchType(..), initModel, decodeUser)
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as Group
import Bootstrap.Button as Button
import Json.Decode as Decode
import Http


signupView: Html Msg
signupView = 
    div [ class "signup-container" ]
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
            , Button.onClick SignupButton
            ]
            [ text "Sign Up" ]
        ]

    
signupCall : User -> Cmd Msg
signupCall user =
    Http.send processSignup <| Http.get ("http://localhost:3000/signup/" ++ user.username ++ "/" ++ user.password) decodeUser


processSignup : Result Http.Error User -> Msg
processSignup result =
    case result of
        Ok user ->
            HandleSignup user

        Err err ->
            HandleError err

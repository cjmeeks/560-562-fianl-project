module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Navigation
import Types exposing (Msg(..), Model, Player, Team, User, initModel, playerSearches, teamSearches)
import Routes exposing (Route(..), parseLocation)
import Bootstrap.CDN as CDN
import Search
import Player
import Team
import Dict
import Array
import Login
import Signup


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = fakeAuth
        , subscriptions = (\_ -> Sub.none)
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init loc =
    ( { initModel | curPage = parseLocation loc }, Cmd.batch [ Team.fetchTeams Dict.empty, Player.fetchPlayers Dict.empty ] )


fakeAuth : Msg -> Model -> ( Model, Cmd Msg )
fakeAuth msg model =
    if (String.isEmpty model.user.username) && (String.isEmpty model.user.password) && (model.curPage /= Login) then
        ( model, Cmd.batch [ Navigation.newUrl "#login", Navigation.reload ] )
    else
        update msg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange loc ->
            ( { model | curPage = parseLocation loc }, Cmd.none )

        LikeInput ( key, value ) ->
            let
                split =
                    String.split "." key

                typeOf =
                    Maybe.withDefault "error" <| Array.get 0 <| Array.fromList split

                newKey =
                    Maybe.withDefault "error" <| Array.get 1 <| Array.fromList split
            in
                case typeOf of
                    "team" ->
                        ( { model | teamQuery = Dict.insert newKey value model.teamQuery }, Cmd.none )

                    "player" ->
                        ( { model | playerQuery = Dict.insert newKey value model.playerQuery }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

        ExactInput ( key, value ) ->
            let
                split =
                    String.split "." key

                typeOf =
                    Maybe.withDefault "error" <| Array.get 0 <| Array.fromList split

                newKey =
                    Maybe.withDefault "error" <| Array.get 1 <| Array.fromList split
            in
                case typeOf of
                    "team" ->
                        ( { model | teamQuery = Dict.insert newKey value model.teamQuery }, Cmd.none )

                    "player" ->
                        ( { model | playerQuery = Dict.insert newKey value model.playerQuery }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

        MoreThanInput ( key, value ) ->
            let
                split =
                    String.split "." key

                typeOf =
                    Maybe.withDefault "error" <| Array.get 0 <| Array.fromList split

                newKey =
                    Maybe.withDefault "error" <| Array.get 1 <| Array.fromList split
            in
                case typeOf of
                    "team" ->
                        ( { model | teamQuery = Dict.insert newKey value model.teamQuery }, Cmd.none )

                    "player" ->
                        ( { model | playerQuery = Dict.insert newKey value model.playerQuery }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

        LessThanInput ( key, value ) ->
            let
                split =
                    String.split "." key

                typeOf =
                    Maybe.withDefault "error" <| Array.get 0 <| Array.fromList split

                newKey =
                    Maybe.withDefault "error" <| Array.get 1 <| Array.fromList split
            in
                case typeOf of
                    "team" ->
                        ( { model | teamQuery = Dict.insert newKey value model.teamQuery }, Cmd.none )

                    "player" ->
                        ( { model | playerQuery = Dict.insert newKey value model.playerQuery }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

        SearchClick ->
            ( model, Cmd.none )

        AddPlayer player ->
            ( { model | favoritePlayers = List.append model.favoritePlayers [ player ] }, Player.addFavPlayer "add" player.id model.user )

        AddTeam team ->
            ( { model | favoriteTeam = team }, Team.addFavTeam "add" team.id model.user )

        DeletePlayer player ->
            ( { model | favoritePlayers = List.filter (\x -> x.firstName /= player.firstName && x.lastName /= player.lastName) model.favoritePlayers }, Player.addFavPlayer "delete" player.id model.user )

        DeleteTeam team ->
            ( { model | favoriteTeam = Team 0 "" "" "" 0 "" 0 0 0 }, Team.addFavTeam "delete" team.id model.user )

        HandleTeams teams ->
            ( { model | teamResults = teams }, Cmd.none )

        HandlePlayers players ->
            ( { model | playerResults = players }, Cmd.none )

        HandleError err ->
            let
                temp =
                    Debug.log "error: " err
            in
                ( model, Cmd.none )

        Search which ->
            let
                cmd =
                    case which of
                        "player" ->
                            Player.fetchPlayers model.playerQuery

                        "team" ->
                            Team.fetchTeams model.teamQuery

                        _ ->
                            Cmd.none
            in
                ( model, cmd )

        Username username ->
            let
                user =
                    model.user
            in
                ( { model | user = { user | username = username } }, Cmd.none )

        Password password ->
            let
                user =
                    model.user
            in
                ( { model | user = { user | password = password } }, Cmd.none )

        HandleUser user ->
            let
                temp =
                    Debug.log "user" user
            in
                ( { model | user = user, curPage = Profile }, Navigation.newUrl "#profile" )

        HandleSignup user ->
            ( { model | user = user, curPage = Profile }, Navigation.newUrl "#login" )

        LoginButton ->
            ( model, Login.loginCall model.user )

        SignupButton ->
            ( model, Signup.signupCall model.user )

        HandleFav bool ->
            let
                temp =
                    Debug.log "Fav back:" bool
            in
                ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model.curPage of
        Profile ->
            div [ class "my-container" ]
                [ nav
                , div [] [ text ("Current User Logged in: " ++ model.user.username) ]
                , div []
                    [ h3 [] [ text "Favorite Team: " ]
                    , if model.favoriteTeam.id == 0 then
                        text "no Favorite Team"
                      else
                        Team.teamTable False [ model.favoriteTeam ]
                    ]
                , div []
                    [ h3 [] [ text "Favorite Players" ]
                    , if model.favoritePlayers == [] then
                        text "no Favorite players"
                      else
                        Player.playerTable False model.favoritePlayers
                    ]
                ]

        TeamResult ->
            div [ class "my-container" ]
                [ nav
                , Search.view "team" teamSearches
                , Team.teamTable True model.teamResults
                ]

        PlayerResult ->
            div [ class "my-container" ]
                [ nav
                , Search.view "player" playerSearches
                , Player.playerTable True model.playerResults
                ]

        Login ->
            div [ class "my-container" ]
                [ h1 [] [ text "Soccer Database" ]
                , CDN.stylesheet
                , Login.loginView
                ]

        SignUp ->
            div [ class "my-container" ]
                [ h1 [] [ text "Sign Up Page" ]
                , CDN.stylesheet
                , Signup.signupView
                ]


nav : Html Msg
nav =
    div [ class "row" ]
        [ CDN.stylesheet
        , ul []
            [ li [] [ a [ href "#profile" ] [ text "Profile" ] ]
            , li [] [ a [ href "#players" ] [ text "Player Search" ] ]
            , li [] [ a [ href "#teams" ] [ text "Team Search" ] ]
            , li [] [ a [ href "#signup" ] [ text "Sign up" ] ]
            ]
        ]

module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Navigation
import Types exposing (Msg(..), Model, Player, Team, initModel, playerSearches, teamSearches)
import Routes exposing (Route(..), parseLocation)
import Bootstrap.CDN as CDN
import Search
import Player
import Team
import Dict


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init loc =
    ( { initModel | curPage = parseLocation loc }, Cmd.batch [ Team.fetchTeams "all" Dict.empty, Player.fetchPlayers "all" Dict.empty ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange loc ->
            ( { model | curPage = parseLocation loc }, Cmd.none )

        LikeInput ( key, value ) ->
            let
                temp =
                    Debug.log "likeinput" ( key, value )
            in
                ( model, Cmd.none )

        ExactInput ( key, value ) ->
            let
                temp =
                    Debug.log "exact" ( key, value )
            in
                ( model, Cmd.none )

        MoreThanInput ( key, value ) ->
            let
                temp =
                    Debug.log "moreThan" ( key, value )
            in
                ( model, Cmd.none )

        LessThanInput ( key, value ) ->
            let
                temp =
                    Debug.log "lessthan" ( key, value )
            in
                ( model, Cmd.none )

        SearchClick ->
            ( model, Cmd.none )

        AddPlayer player ->
            ( { model | favoritePlayers = List.append model.favoritePlayers [ player ] }, Cmd.none )

        AddTeam team ->
            ( { model | favoriteTeams = List.append model.favoriteTeams [ team ] }, Cmd.none )

        DeletePlayer player ->
            ( { model | favoritePlayers = List.filter (\x -> x.firstName /= player.firstName && x.lastName /= player.lastName) model.favoritePlayers }, Cmd.none )

        DeleteTeam team ->
            ( { model | favoriteTeams = List.filter (\x -> x.name /= team.name) model.favoriteTeams }, Cmd.none )

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


view : Model -> Html Msg
view model =
    case model.curPage of
        Profile ->
            div [ class "my-container" ]
                [ nav
                , div [] [ text "profile" ]
                , Team.teamTable False model.favoriteTeams
                , Player.playerTable False model.favoritePlayers
                ]

        TeamResult ->
            div [ class "my-container" ]
                [ nav
                , Search.view teamSearches
                , Team.teamTable True model.teamResults
                ]

        PlayerResult ->
            div [ class "my-container" ]
                [ nav
                , Search.view playerSearches
                , Player.playerTable True model.playerResults
                ]


nav : Html Msg
nav =
    div [ class "row" ]
        [ CDN.stylesheet
        , ul []
            [ li [] [ a [ href "#profile" ] [ text "Profile" ] ]
            , li [] [ a [ href "#players" ] [ text "Player Search" ] ]
            , li [] [ a [ href "#teams" ] [ text "Team Search" ] ]
            ]
        ]

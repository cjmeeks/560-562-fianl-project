module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Navigation
import Types exposing (Msg(..), Model, Player, Team, initModel)
import Routes exposing (Route(..), parseLocation)
import Bootstrap.CDN as CDN
import Search


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
    ( { initModel | curPage = parseLocation loc }, Cmd.none )


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


view : Model -> Html Msg
view model =
    case model.curPage of
        Profile ->
            div [ class "my-container" ]
                [ nav
                , div [] [ text "profile" ]
                ]

        Search ->
            div [ class "my-container" ]
                [ nav
                , Search.view
                ]


nav : Html Msg
nav =
    div [ class "row" ]
        [ CDN.stylesheet
        , ul []
            [ li [] [ a [ href "#profile" ] [ text "Profile" ] ]
            , li [] [ a [ href "#search" ] [ text "Search" ] ]
            ]
        ]

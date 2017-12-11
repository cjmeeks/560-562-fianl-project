module Routes exposing (..)

import Navigation
import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top, oneOf, map, parseHash, Parser)


type Route
    = Profile
    | TeamResult
    | PlayerResult
    | Login
    | SignUp


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Login top
        , map Login (s "login")
        , map SignUp (s "signup")
        , map Profile (s "profile")
        , map TeamResult (s "teams")
        , map PlayerResult (s "players")
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            Profile

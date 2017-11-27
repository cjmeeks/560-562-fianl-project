module Routes exposing (..)

import Navigation
import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top, oneOf, map, parseHash, Parser)


type Route
    = Profile
    | PSearch
    | TSearch
    | TeamResult
    | PlayerResult


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Profile top
        , map Profile (s "profile")
        , map PSearch (s "pSearch")
        , map TSearch (s "tSearch")
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

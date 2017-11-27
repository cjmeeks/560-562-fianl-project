module Routes exposing (..)

import Navigation
import UrlParser as Url exposing ((</>), (<?>), s, int, stringParam, top, oneOf, map, parseHash, Parser)


type Route
    = Profile
    | Search
    | Result


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Profile top
        , map Profile (s "profile")
        , map Search (s "search")
        , map Result (s "result")
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            Search

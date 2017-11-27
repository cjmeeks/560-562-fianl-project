module Types exposing (..)

import Navigation
import Json.Decode exposing (Decoder, string, int)
import Json.Decode.Pipeline exposing (decode, optional)
import Routes exposing (Route(..))


type alias Player =
    { firstName : String
    , lastName : String
    , position : String
    , jerseyNumber : Int
    , salary : Int
    , teamName : String
    }


decodePlayer : Decoder Player
decodePlayer =
    decode Player
        |> optional "firstName" string "nothing"
        |> optional "lastName" string "nothing"
        |> optional "position" string "nothing"
        |> optional "jerseyNumber" int -1
        |> optional "salary" int -1
        |> optional "teamName" string "nothing"


type alias Team =
    { name : String
    , league : String
    , city : String
    , yearFounded : Int
    , coachName : String
    , wins : Int
    , losses : Int
    , ties : Int
    }


decodeTeam : Decoder Team
decodeTeam =
    decode Team
        |> optional "name" string "nothing"
        |> optional "league" string "nothing"
        |> optional "city" string "nothing"
        |> optional "yearFounded" int -1
        |> optional "coachName" string "nothing"
        |> optional "wins" int -1
        |> optional "losses" int -1
        |> optional "ties" int -1


type SearchType
    = Like
    | Number


playerSearches : List ( String, List ( String, SearchType ) )
playerSearches =
    [ ( "Player"
      , [ ( "firstName", Like )
        , ( "lastName", Like )
        , ( "teamName", Like )
        , ( "position", Like )
        ]
      )
    ]


teamSearches : List ( String, List ( String, SearchType ) )
teamSearches =
    [ ( "Team"
      , [ ( "teamName", Like )
        , ( "league", Like )
        , ( "country", Like )
        ]
      )
    ]


listOfQueryParams : List ( String, List ( String, SearchType ) )
listOfQueryParams =
    [ ( "Country"
      , [ ( "country_name", Like )
        , ( "country_continent", Like )
        ]
      )
    , ( "League"
      , [ ( "league_name", Like )
        ]
      )
    , ( "People"
      , [ ( "people_first_name", Like )
        , ( "people_last_name", Like )
        , ( "people_nationality", Like )
        ]
      )
    , ( "Player"
      , [ ( "player_number", Number )
        , ( "player_position", Like )
        ]
      )
    , ( "Stadium"
      , [ ( "stadium_name", Like )
        , ( "stadium_city", Like )
        , ( "stadium_capacity", Number )
        , ( "stadium_yearFounded", Number )
        ]
      )
    , ( "Team"
      , [ ( "team_name", Like )
        , ( "team_yearFounded", Like )
        ]
      )
    , ( "Contracts"
      , [ ( "contract_salary", Number )
        , ( "contract_years", Number )
        ]
      )
    , ( "Season"
      , [ ( "season_wins", Number )
        , ( "season_losses", Number )
        , ( "season_ties", Number )
        ]
      )
    , ( "Coach"
      , [ ( "coach_yearHired", Number )
        ]
      )
    ]


type alias Model =
    { favoriteTeams : List Team
    , teamResults : List Team
    , favoritePlayers : List Player
    , playerResults : List Player
    , curPage : Route
    , fetching : Data
    }


initModel : Model
initModel =
    { favoriteTeams = []
    , teamResults = []
    , favoritePlayers = []
    , playerResults = []
    , curPage = Profile
    , fetching = Noop
    }


type Data
    = Searching
    | Noop
    | Back


type Msg
    = UrlChange Navigation.Location
    | LikeInput ( String, String )
    | ExactInput ( String, String )
    | MoreThanInput ( String, String )
    | LessThanInput ( String, String )
    | SearchClick

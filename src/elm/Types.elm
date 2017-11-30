module Types exposing (..)

import Navigation
import Json.Decode exposing (Decoder, string, int, float)
import Json.Decode.Pipeline exposing (decode, optional)
import Routes exposing (Route(..))
import Http
import Dict


type alias Player =
    { firstName : String
    , lastName : String
    , position : String
    , jerseyNumber : Int
    , salary : Float
    , teamName : String
    }


initPlayer =
    { firstName = " asdf"
    , lastName = " asdf"
    , position = " asdf"
    , jerseyNumber = 0
    , salary = 0
    , teamName = " asdf"
    }


decodePlayer : Decoder Player
decodePlayer =
    decode Player
        |> optional "firstName" string "nothing"
        |> optional "lastName" string "nothing"
        |> optional "position" string "nothing"
        |> optional "number" int -1
        |> optional "salary" float -1
        |> optional "name" string "nothing"


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


initTeam =
    { name = "team"
    , league = "team"
    , city = "team"
    , yearFounded = 0
    , coachName = "team"
    , wins = 0
    , losses = 0
    , ties = 0
    }


decodeTeam : Decoder Team
decodeTeam =
    decode Team
        |> optional "name" string "nothing"
        |> optional "leagueName" string "nothing"
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
      , [ ( "player.firstName", Like )
        , ( "player.lastName", Like )
        , ( "player.teamName", Like )
        , ( "player.position", Like )
        ]
      )
    ]


teamSearches : List ( String, List ( String, SearchType ) )
teamSearches =
    [ ( "Team"
      , [ ( "team.teamName", Like )
        , ( "team.league", Like )
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
    , playerQuery : Dict.Dict String String
    , teamQuery : Dict.Dict String String
    }


initModel : Model
initModel =
    { favoriteTeams = []
    , teamResults = []
    , favoritePlayers = []
    , playerResults = []
    , curPage = Profile
    , fetching = Noop
    , playerQuery = Dict.empty
    , teamQuery = Dict.empty
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
    | AddPlayer Player
    | AddTeam Team
    | DeleteTeam Team
    | DeletePlayer Player
    | HandleTeams (List Team)
    | HandlePlayers (List Player)
    | HandleError Http.Error
    | Search String

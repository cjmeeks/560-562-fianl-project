module Types exposing (..)

import Navigation
import Json.Decode exposing (Decoder, string, int)
import Json.Decode.Pipeline exposing (decode, optional)
import Routes exposing (Route(..))


type alias Result =
    { country_code : String
    , country_name : String
    , country_continent : String
    , league_id : Int
    , league_name : String
    , league_yearFounded : Int
    , stadium_id : Int
    , stadium_name : String
    , stadium_city : String
    , stadium_yearOpened : Int
    , stadium_capacity : Int
    , stadium_locationCode : String
    , people_id : Int
    , people_first_name : String
    , people_last_name : String
    , people_nationality : String
    , player_id : Int
    , player_number : Int
    , player_position : String
    , team_id : Int
    , team_name : String
    , team_yearFounded : Int
    , team_playsInLeague : Int
    , team_homeStadium : Int
    , contract_player : Int
    , contract_salary : Int
    , contract_years : Int
    , contract_team : Int
    , season_team : Int
    , season_dateStarted : String
    , season_dateEnded : String
    , season_wins : Int
    , season_losses : Int
    , season_ties : Int
    , coach_id : Int
    , coach_yearHired : Int
    , coach_team : Int
    }


decodeResult : Decoder Result
decodeResult =
    decode Result
        |> optional "country_code" string "nothing"
        |> optional "country_name" string "nothing"
        |> optional "country_continent" string "nothing"
        |> optional "league_id" int -1
        |> optional "league_name" string "nothing"
        |> optional "league_yearFounded" int -1
        |> optional "stadium_id" int -1
        |> optional "stadium_name" string "nothing"
        |> optional "stadium_city" string "nothing"
        |> optional "stadium_yearOpened" int -1
        |> optional "stadium_capacity" int -1
        |> optional "stadium_locationCode" string "nothing"
        |> optional "people_id" int -1
        |> optional "people_first_name" string "nothing"
        |> optional "people_last_name" string "nothing"
        |> optional "people_nationality" string "nothing"
        |> optional "player_id" int -1
        |> optional "player_number" int -1
        |> optional "player_position" string "nothing"
        |> optional "team_id" int -1
        |> optional "team_name" string "nothing"
        |> optional "team_yearFounded" int -1
        |> optional "team_playsInLeague" int -1
        |> optional "team_homeStadium" int -1
        |> optional "contract_player" int -1
        |> optional "contract_salary" int -1
        |> optional "contract_years" int -1
        |> optional "contract_team" int -1
        |> optional "season_team" int -1
        |> optional "season_dateStarted" string "nothing"
        |> optional "season_dateEnded" string "nothing"
        |> optional "season_wins" int -1
        |> optional "season_losses" int -1
        |> optional "season_ties" int -1
        |> optional "coach_id" int -1
        |> optional "coach_yearHired" int -1
        |> optional "coach_team" int -1


type SearchType
    = Like
    | Number


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


type alias Player =
    { people_id : Int
    , people_first_name : String
    , people_last_name : String
    , people_nationality : String
    , player_id : Int
    , player_number : Int
    , player_position : String
    }


decodePlayer : Decoder Player
decodePlayer =
    decode Player
        |> optional "people_id" int -1
        |> optional "people_first_name" string "nothing"
        |> optional "people_last_name" string "nothing"
        |> optional "people_nationality" string "nothing"
        |> optional "player_id" int -1
        |> optional "player_number" int -1
        |> optional "player_position" string "nothing"


type alias Team =
    { team_id : Int
    , team_name : String
    , team_yearFounded : Int
    , team_playsInLeague : Int
    , team_homeStadium : Int
    }


decodeTeam : Decoder Team
decodeTeam =
    decode Team
        |> optional "team_id" int -1
        |> optional "team_name" string "nothing"
        |> optional "team_yearFounded" int -1
        |> optional "team_playsInLeague" int -1
        |> optional "team_homeStadium" int -1


type alias Model =
    { results : List Result
    , favoriteTeam : Maybe Team
    , favoritePlayer : Maybe Player
    , curPage : Route
    }


initModel : Model
initModel =
    { results = []
    , favoriteTeam = Nothing
    , favoritePlayer = Nothing
    , curPage = Profile
    }


type Msg
    = UrlChange Navigation.Location
    | LikeInput ( String, String )
    | ExactInput ( String, String )
    | MoreThanInput ( String, String )
    | LessThanInput ( String, String )

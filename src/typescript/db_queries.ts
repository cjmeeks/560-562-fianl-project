const mysql = require('mysql');
const connection = mysql.createConnection({
    host        : '165.227.120.198',
    user        : '562_demo',
    password    : '562_password',
    database    : 'soccer_562',
    port        : '3306'
});

// Player Queries
const SELECT_ALL_PLAYERS_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID;";

const SELECT_PLAYER_FNAME_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE people.firstName LIKE \"%?%\";";

const SELECT_PLAYER_LNAME_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE people.lastName LIKE \"%?%\";";

const SELECT_PLAYER_NAME_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\";";

const SELECT_PLAYER_TEAM_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE teams.name LIKE \"%?%\";";

const SELECT_PLAYER_POS_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE players.position LIKE \"%?%\";";

const SELECT_PLAYER_NAME_TEAM_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\") AND (teams.name LIKE \"%?%\");";

const SELECT_PLAYER_NAME_POS_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\") AND (players.position LIKE \"%?%\");";

const SELECT_PLAYER_TEAM_POS_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (teams.name LIKE \"%?%\") AND (players.position LIKE \"%?%\");";

const SELECT_PLAYER_NAME_TEAM_POS_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\") AND (players.position LIKE \"%?%\") AND (teams.name LIKE \"%?%\");";

const SELECT_USER_PLAYER_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "INNER JOIN user_favorite_players ON players.player_id=user_favorite_players.favoritePlayer\n"
                                        + "WHERE user_favorite_players.username = ?;";

// Team Queries
const SELECT_ALL_TEAMS_QUERY: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "LEFT JOIN seasons ON teams.teamID=seasons.teamID;";

const SELECT_TEAM_NAME_QUERY: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                                    + "WHERE teams.name LIKE \"%?%\";";

const SELECT_TEAM_LEAGUE_QUERY: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                                    + "WHERE leagues.name LIKE \"%?%\";";

const SELECT_TEAM_NAME_LEAGUE_QUERY: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                                    + "WHERE (teams.name LIKE \"%?%\") AND (leagues.name LIKE \"%?%\");";

const SELECT_TEAM_ID_QUERY: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                                    + "WHERE teams.teamID = ?;";

// Sign in and Login SQL Calls
const CHECK_IF_USERNAME_EXISTS_QUERY: string = "SELECT users.username\n"
                                    + "FROM users;";

const CHECK_LOGIN_QUERY: string = "SELECT *\n"
                                + "FROM users\n"
                                + "WHERE ((users.username LIKE ?) AND (users.password LIKE ?));";

const INSERT_NEW_USER_QUERY: string = "INSERT INTO users(username, password)\n"
                                    + "VALUES(?, ?);";

// User interaction SQL Calls
const INSERT_FAVORITE_USER_PLAYER_QUERY: string = "INSERT INTO user_favorite_players(username,favoritePlayer)\n"
                                                + "VALUES(?, ?);"

const DELETE_FAVORITE_USER_PLAYER_QUERY: string = "DELETE FROM user_favorite_players\n"
                                                + "WHERE (username LIKE \"?\") AND (favoritePlayer = ?);"

const UPDATE_FAVORITE_USER_TEAM_QUERY: string = "UPDATE users\n"
                                                + "SET favoriteTeam = ?\n"
                                                + "WHERE users.username LIKE \"?\";";

const DELETE_FAVORITE_USER_TEAM_QUERY: string = "UPDATE users\n"
                                                + "SET favoriteTeam = NULL\n"
                                                + "WHERE users.username LIKE \"?\";";

// Advanced player SQL calls
const SEARCH_SALARY_SPECIFIC_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE contract.salary = ?;";

const SEARCH_SALARY_BETWEEN_QUERY: string = "SELECT players.player_ID, people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE contract.salary BETWEEN ? AND ?;";

// Team wins, losses, ties SQL calls
const TEAM_WINS_SQL: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                            + "FROM teams\n"
                            + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                            + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                            + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                            + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                            + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                            + "WHERE seasons.wins = ?;";

const TEAM_LOSSES_SQL: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                + "FROM teams\n"
                                + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                                + "WHERE seasons.losses = ?;";

const TEAM_TIES_SQL: string = "SELECT teams.teamID, teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, \" \", people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                            + "FROM teams\n"
                            + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                            + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                            + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                            + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                            + "LEFT JOIN seasons ON teams.teamID=seasons.teamID\n"
                            + "WHERE seasons.ties = ?;";

// Number of players per position
const NUM_PLAYERS_PER_POS_SQL: string = "SELECT players.position, COUNT(*) as num_at_position\n"
                                        + "FROM players\n"
                                        + "GROUP BY players.position;";

// Sum of salaries for team
const SUM_OF_SALARIES_FOR_TEAM_SQL: string = "SELECT teams.name, SUM(contract.salary) as total_contracts\n"
                                            + "FROM teams\n"
                                            + "INNER JOIN contract ON teams.teamID=contract.teamID\n"
                                            + "WHERE teams.name LIKE \"?\";";

// Player SQL calls
export function players_query(callback) {
    connection.query(SELECT_ALL_PLAYERS_QUERY, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_name_search_query(params, callback) {
    //Expecting params to be a list with two entries.
    var inserts = [params[0], params[1]];
    var sql_query = mysql.format(SELECT_PLAYER_NAME_QUERY, inserts);
    let count = 0;
    while (count < 4) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_team_search_query(params, callback) {
    //Expecting params to be a single variable.
    var inserts = [params];
    var sql_query = mysql.format(SELECT_PLAYER_TEAM_QUERY, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_pos_search_query(params, callback) {
    //Expecting params to be a single variable with the position being searched for.
    var inserts = params;
    var sql_query = mysql.format(SELECT_PLAYER_POS_QUERY, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_team_and_name_search_query(params, callback) {
    //Expecting first two params to be name params and third to be team param.
    var inserts = [params[0], params[1], params[2]];
    var sql_query = mysql.format(SELECT_PLAYER_NAME_TEAM_QUERY, inserts);
    let count = 0;
    while (count < 6) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_team_pos_search_query(params, callback) {
    //Expecting first param to be the team being searched for and the second param to be the position.
    var inserts = [params[0], params[1]];
    var sql_query = mysql.format(SELECT_PLAYER_TEAM_POS_QUERY, inserts);
    let count = 0;
    while (count < 4) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_name_pos_search_query(params, callback) {
    //Expecting first two params to be name params and third to be position param.
    var inserts = [params[0], params[1], params[2]];
    var sql_query = mysql.format(SELECT_PLAYER_NAME_POS_QUERY, inserts);
    let count = 0;
    while (count < 6) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function players_team_name_and_pos_search_query(params, callback) {
    //Expecting first two params to be name params, third to be position param, and fourth to be team param.
    var inserts = [params[0], params[1], params[2], params[3]];
    var sql_query = mysql.format(SELECT_PLAYER_NAME_TEAM_POS_QUERY, inserts);
    let count = 0;
    while (count < 8) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}
export function user_players_query(params, callback) {
    //Expecting first two params to be name params, third to be position param, and fourth to be team param.
    var inserts = params;
    var sql_query = mysql.format(SELECT_USER_PLAYER_QUERY, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}


// Teams SQL Calls
export function teams_query(callback) {
    connection.query(SELECT_ALL_TEAMS_QUERY, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function teams_name_search_query(params, callback) {
    //Expecting params to be team name param.
    var inserts = params;
    var sql_query = mysql.format(SELECT_TEAM_NAME_QUERY, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function teams_league_search_query(params, callback) {
    //Expecting params to be team league param.
    var inserts = params;
    var sql_query = mysql.format(SELECT_TEAM_LEAGUE_QUERY, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function teams_name_league_search_query(params, callback) {
    //Expecting params to be a list with the first element being team name and second being team league.
    var inserts = [params[0], params[1]];
    var sql_query = mysql.format(SELECT_TEAM_NAME_LEAGUE_QUERY, inserts);
    let count = 0;
    while (count < 4) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function user_team_query(params, callback) {
    //Expecting params to be a list with the first element being team name and second being team league.
    var inserts = params;
    var sql_query = mysql.format(SELECT_TEAM_ID_QUERY, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

// Signup and Login SQL Calls
export function get_username_query(callback) {
    connection.query(CHECK_IF_USERNAME_EXISTS_QUERY, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function insert_new_user_query(params, callback) {
    //Expecting params to be a list with two params, username and password
    var inserts = [params[0], params[1]];
    var sql_query = mysql.format(INSERT_NEW_USER_QUERY, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function check_login_query(params, callback) {
    //Expecting params to be a list with two params, username and password
    var inserts = [params[0], params[1]];
    var sql_query = mysql.format(CHECK_LOGIN_QUERY, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

// User interaction SQL Calls.
export function update_favorite_player_query(params, callback) {
    //Expecting params to be two variables, first a username and second a playerID.
    var inserts = [params[0], parseInt(params[1])];
    var sql_query = mysql.format(INSERT_FAVORITE_USER_PLAYER_QUERY, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function update_favoite_team_query(params, callback) {
    //Expecting params to be two variables, first a teamID and second a username.
    var inserts = [parseInt(params[0]), params[1]];
    var sql_query = mysql.format(UPDATE_FAVORITE_USER_TEAM_QUERY, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function delete_favorite_player_query(params, callback) {
    //Expecting params to be two variables, a username and a playerID.
    var inserts = [params[0], parseInt(params[1])];
    var sql_query = mysql.format(DELETE_FAVORITE_USER_PLAYER_QUERY, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function delete_favorite_team_query(params, callback) {
    //Expecting params to be one variable, a username.
    var inserts = params;
    var sql_query = mysql.format(DELETE_FAVORITE_USER_TEAM_QUERY, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

// Salary SQL functions
export function select_salary_exact_amount_query(params, callback) {
    //Expecting params to be one variable, a salary.
    var inserts = params;
    var sql_query = mysql.format(SEARCH_SALARY_SPECIFIC_QUERY, inserts);
    // var count = 0;
    // while (count < 2) {
    //     sql_query = sql_query.replace("'", "");
    //     count++;
    // }
    console.log(sql_query)
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function select_salary_between_amounts_query(params, callback) {
    //Expecting params to be a list, with first entry being low salary and second entry being high salary.
    var inserts = params;
    var sql_query = mysql.format(SEARCH_SALARY_BETWEEN_QUERY, inserts);
    // var count = 0;
    // while (count < 2) {
    //     sql_query = sql_query.replace("'", "");
    //     count++;
    // }
    console.log(sql_query)
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

// Team record SQL functions
export function select_team_wins_query(params, callback) {
    var inserts = params;
    var sql_query = mysql.format(TEAM_WINS_SQL, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function select_team_losses_query(params, callback) {
    var inserts = params;
    var sql_query = mysql.format(TEAM_LOSSES_SQL, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function select_team_ties_query(params, callback) {
    var inserts = params;
    var sql_query = mysql.format(TEAM_TIES_SQL, inserts);
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

// Etc functions
export function num_players_per_pos_query(params, callback) {
    connection.query(NUM_PLAYERS_PER_POS_SQL, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function sum_salaries_teams_query(params, callback) {
    // Expecting a team name
    var inserts = params;
    var sql_query = mysql.format(SUM_OF_SALARIES_FOR_TEAM_SQL, inserts);
    let count = 0;
    while (count < 2) {
        sql_query = sql_query.replace("'", "");
        count++;
    }
    connection.query(sql_query, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}
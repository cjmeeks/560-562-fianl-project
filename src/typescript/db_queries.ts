const mysql = require('mysql');
const connection = mysql.createConnection({
    host        : '165.227.120.198',
    user        : '562_demo',
    password    : '562_password',
    database    : 'soccer_562',
    port        : '3306'
});

// Player Queries
const SELECT_ALL_PLAYERS_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID;";

const SELECT_PLAYER_FNAME_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE people.firstName LIKE \"%?%\";";
const SELECT_PLAYER_LNAME_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE people.lastName LIKE \"%?%\";";

const SELECT_PLAYER_NAME_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\";";

const SELECT_PLAYER_TEAM_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE teams.name LIKE \"%?%\";";

const SELECT_PLAYER_NAME_TEAM_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\") AND (teams.name LIKE \"%?%\");";

const SELECT_PLAYER_NAME_TEAM_POSITION_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (people.firstName LIKE \"%?%\" OR people.lastName LIKE \"%?%\") AND (teams.name LIKE \"%?%\") AND (player.position LIKE \"%?%\");";

const SELECT_PLAYER_TEAM_POSITION_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE (teams.name LIKE \"%?%\") AND (player.position LIKE \"%?%\");";

const SELECT_PLAYER_POSITION_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID\n"
                                        + "WHERE player.position LIKE \"%?%\";";

//////////////////// Team Queries
const SELECT_ALL_TEAMS_QUERY: string = "SELECT teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, ' ', people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "INNER JOIN seasons ON teams.teamID=seasons.teamID;";


// User Interaction Queries (signin, logon)
const CHECK_IF_USERNAME_EXISTS_QUERY: string = "SELECT users.username\n"
                                    + "FROM users;";

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
    var inserts = params;
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
    //TODO: complete function.
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

export function players_team_name_and_pos_search_query(params, callback) {
    //TODO: complete this function.
}

export function players_team_pos_search_query(params, callback) {
    //TODO: complete this function.
}

export function players_name_pos_search_query(params, callback) {
    //TODO: complete this function. 
}
export function players__pos_search_query(params, callback) {
    //TODO: complete this function. 
}

// Teams SQL Calls
export function teams_query(callback) {
    connection.query(SELECT_ALL_TEAMS_QUERY, function(error, results, fields) {
        if (error) throw error;
        callback(results)
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
}

export function check_login_query(params, callback) {
    //Expecting params to be a list with two params, username and password
    var inserts = [params[0], params[1]];
}
const mysql = require('mysql');
const connection = mysql.createConnection({
    host        : '165.227.120.198',
    user        : '562_demo',
    password    : '562_password',
    database    : 'soccer_562',
    port        : '3306'
});

const SELECT_ALL_PLAYERS_QUERY: string = "SELECT people.firstName,people.lastName,players.position,players.number,contract.salary,teams.name\n"
                                        + "FROM people\n"
                                        + "INNER JOIN players ON people.people_ID=players.player_ID\n"
                                        + "INNER JOIN contract ON people.people_ID=contract.player_ID\n"
                                        + "INNER JOIN teams ON contract.teamID=teams.teamID;"

const SELECT_ALL_TEAMS_QUERY: string= "SELECT teams.name,leagues.name as leagueName,stadiums.city,teams.yearFounded, concat(people.firstName, ' ', people.lastName) as coachName, seasons.wins, seasons.losses, seasons.ties\n"
                                    + "FROM teams\n"
                                    + "INNER JOIN leagues ON teams.playsInLeague=leagues.leagueID\n"
                                    + "INNER JOIN stadiums ON teams.homeStadium=stadiums.stadiumID\n"
                                    + "INNER JOIN coaches ON teams.teamID=coaches.teamCoaching\n"
                                    + "INNER JOIN people ON coaches.coach_ID=people.people_ID\n"
                                    + "INNER JOIN seasons ON teams.teamID=seasons.teamID;"

export function players_query(callback) {
    connection.query(SELECT_ALL_PLAYERS_QUERY, function(error, results, fields) {
        if (error) throw error;
        callback(results);
    })
}

export function teams_query(callback) {
    connection.query(SELECT_ALL_TEAMS_QUERY, function(error, results, fields) {
        if (error) throw error;
        callback(results)
    })
}
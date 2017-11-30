import * as db_conn from "./db_queries"

export function filler() {
    console.log("hello");
}

//Checks to see if the username is in use. Returns true if it is and false if it isn't
export function checkUsername(usernameToCheck, password) {
    var users = db_conn.get_username_query(function(data) {
        for (let result of data) {
            if (result === usernameToCheck) {
                return;
            }
        }
        createNewUser(usernameToCheck, password);
    })
}

function createNewUser(username, password) {
    let params = [username, password];
    var insertedUser = db_conn.insert_new_user_query(params, function(data) {
        return;
    })
}

//Checks the passed username and password against the database to see if the provided info is a registered user.
export function checkLogin(usernameToCheck, passwordToCheck, callback) {
    let params = [usernameToCheck, passwordToCheck];
    var checkedUser = db_conn.check_login_query(params, function(data) {
        return data;
    })
}
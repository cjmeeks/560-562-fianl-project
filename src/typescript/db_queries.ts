var mysql = require('mysql');
var connection = mysql.createConnection({
    host     : '165.227.120.198',
    user     : '562_demo',
    password : '562_password',
    database : 'soccer_562',
    port     : 3306
});

connection.connect();

/*connection.query("SELECT * FROM people", function(err, results, fields) {
    if(err) {
        console.log("Error while performing query: " + err);
    }
    else {
        for (let result in results) {
            console.log(result);
        }
    }
})*/

connection.end();
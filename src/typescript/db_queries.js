var mysql = require('mysql');
var connection = mysql.createConnection({
    host: '165.227.120.198',
    user: '562_demo',
    password: '562_password',
    database: 'soccer_562',
    port: '3306'
});
connection.connect();
connection.query('SELECT * FROM people', function (error, results, fields) {
    if (error)
        throw error;
    for (var _i = 0, results_1 = results; _i < results_1.length; _i++) {
        var result = results_1[_i];
        console.log(result);
    }
});
connection.end();

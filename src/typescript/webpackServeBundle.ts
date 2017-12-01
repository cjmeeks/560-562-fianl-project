const config = require('./../webpack.config.js')
const webpack = require('webpack')
const webpackMiddleware = require('webpack-dev-middleware')
const webpackHotMiddleware = require('webpack-hot-middleware')

import * as db_conn from "./db_queries"
import * as userLoginSignup from "./userLogin_Signup"

var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : '165.227.120.198',
  user     : '562_demo',
  password : '562_password',
  database : 'soccer_562'
});

module.exports = app => {
  const compiler = webpack(config)
  const middleware = webpackMiddleware(compiler, {
    publicPath: config.output.publicPath,
    stats: {
      colors: true,
      hash: true,
      timings: true,
      chunks: false,
      chunkModules: false,
      modules: false
    }
  })

  app.use(middleware)
  app.use(webpackHotMiddleware(compiler))
  app.get('/', (req, res) => {
    res.write(middleware.fileSystem.readFileSync(path.join(__dirname, '/../dist/index.html')))
    res.end()
  })

  //Player Endpoints
  app.get('/getAllPlayers', (req,res) =>{
    var players = db_conn.players_query(function(data){
      res.send(data)
    })
  })
  //this route needs to check if fname or lname = "nothing" then do query off of that
  app.get('/getPlayers/:fName/:lName', (req,res) =>{
    var newInserts = [req.params.fName, req.params.lName ]
    var players = db_conn.players_name_search_query(newInserts, function(data) {
      res.send(data);
    })
  })
  app.get('/getPlayers/byTeam/:tName', (req,res) =>{
    var newInserts = [req.params.tName ]
    var players = db_conn.players_team_search_query(newInserts, function(data) {
      res.send(data);
    })
  })
  app.get('/getPlayers/:fName/:lName/:teamName', (req,res) =>{
    var newInserts = [req.params.fName, req.params.lName, req.params.teamName ]
    var players = db_conn.players_team_and_name_search_query(newInserts, function(data) {
      res.send(data);
    })
  })
  app.get('/getPlayers/:fName/:lName/:teamName/:position', (req,res) =>{
    var newInserts = [req.params.fName, req.params.lName, req.params.teamName, req.params.position ]
    var players = db_conn.players_team_name_and_pos_search_query(newInserts, function(data) {
      res.send(data);
    })
  })
  app.get('/getPlayers/:position', (req,res) =>{
    var newInserts = [ req.params.position ]
    var players = db_conn.players_pos_search_query(newInserts, function(data) {
      res.send(data);
    })
  })
  app.get('/getPlayers/tp/:teamName/:position', (req,res) =>{
    var newInserts = [ req.params.teamName, req.params.position ]
    var players = db_conn.players_team_pos_search_query(newInserts, function(data) {
      res.send(data);
    })
  })

  app.get('/getPlayers/flp/:fName/:lName/:position', (req,res) =>{
    var newInserts = [req.params.fName, req.params.lName, req.params.position ]
    var players = db_conn.players_name_pos_search_query(newInserts, function(data) {
      res.send(data);
    })
  })

  //Team Endpoints
  app.get('/getAllTeams', (req,res) =>{
    var teams = db_conn.teams_query(function(data){
      res.send(data)
    })
  })

  app.get('/getTeams/:tName', (req,res) =>{
    var newInserts = req.params.tName
    var teams = db_conn.teams_name_search_query(newInserts, function(data) {
      res.send(data);
    })
  })

  app.get('/getTeams/:tName/:league', (req,res) =>{
    var newInserts = [ req.params.teamName, req.params.league ]
    var teams = db_conn.teams_name_league_search_query(newInserts, function(data) {
      res.send(data);
    })
  })
  //need to have diff route when same number of params given
  app.get('/getTeams/league/:league', (req,res) =>{
    var newInserts = req.params.league
    var teams = db_conn.teams_league_search_query(newInserts, function(data) {
      res.send(data);
    })
  })

  //these implementations tbd
  //they need exact greater than less than and between for each
  // for implementation of advanced search
  app.get('/getTeams/:wins', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getTeams/:losses', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getTeams/:ties', (req,res) =>{
    res.send(req.params)
  })


  //Login Endpoints
  app.get('/signup/:username/:password', (req, res) => {
    userLoginSignup.checkUsername(req.params.username, req.params.password, function(data) {
      res.send(data);
    })
  })

  app.get('/login/:user/:password', (req, res) => {
    userLoginSignup.checkLogin(req.params.user, req.params.password, function(data) {
      res.send(data);
    })
  })

  //favorite

  app.get('/favPlayer/add/:id/:user', (req,res) =>{
    var newInserts = [ req.params.user, req.params.id ]
    var players = db_conn.update_favorite_player_query(newInserts, function(data) {
      res.send(true);
    })
  })
  app.get('/favPlayer/delete/:id/:user', (req,res) =>{
    var newInserts = [ req.params.user, req.params.id ]
    var players = db_conn.delete_favorite_player_query(newInserts, function(data) {
      res.send(true);
    })
  })

  app.get('/favTeam/add/:id/:user', (req,res) =>{
    var newInserts = [ req.params.id, req.params.user ]
    var players = db_conn.update_favoite_team_query(newInserts, function(data) {
      res.send(true);
    })
  })
  app.get('/favTeam/delete/:id/:user', (req,res) =>{
    var newInserts = req.params.user
    var players = db_conn.delete_favorite_team_query(newInserts, function(data) {
      res.send(true);
    })
  })

  //Test Endpoints
  app.get('/testEndpoint', (req, res) => {
    var inserts = ["erso", "erso", "Sporting"];
    var players = db_conn.players_team_and_name_search_query(inserts, function(data) {
      res.send(data);
    })
  })

  app.get('/hello', (req,res) =>{
    res.send('helloWorld ' + req.query.name)
  })
}



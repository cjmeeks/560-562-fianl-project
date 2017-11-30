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
  app.get('/getPlayers/:fName', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getPlayers/:lName', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getPlayers/:fName/:lName', (req,res) =>{
    var newInserts = [req.params.fName, req.params.lName ]
    var players = db_conn.players_name_search_query(newInserts, function(data) {
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
    res.send(req.params)
  })
  app.get('/getPlayers/:position', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getPlayers/:teamName/:position', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getPlayers/:fName/:lName/:position', (req,res) =>{
    res.send(req.params)
  })

  //Team Endpoints
  app.get('/getAllTeams', (req,res) =>{
    var teams = db_conn.teams_query(function(data){
      res.send(data)
    })
  })

  app.get('/getTeams/:tName', (req,res) =>{
    res.send(req.params)
  })

  app.get('/getTeams/:tName/:league', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getTeams/:league', (req,res) =>{
    res.send(req.params)
  })
  app.get('/getTeams/:tName', (req,res) =>{
    res.send(req.params)
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
  app.get('/signup', (req, res) => {
    userLoginSignup.filler();
  })

  app.get('/login', (req, res) => {
    userLoginSignup.filler();
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



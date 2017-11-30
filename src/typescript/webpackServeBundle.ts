const config = require('./../webpack.config.js')
const webpack = require('webpack')
const webpackMiddleware = require('webpack-dev-middleware')
const webpackHotMiddleware = require('webpack-hot-middleware')

import * as db_conn from "./db_queries"

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
  app.get('/hello', (req,res) =>{
    res.send('helloWorld')
  })
  app.get('/getPlayers', (req, res) => {
    db_conn.players_query();
  })
  app.get('/getTeams', (req, res) => {
    db_conn.teams_query();
  })
}



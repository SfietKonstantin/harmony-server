express = require 'express'
routes = require './routes/routes'
path = require 'path'
https = require 'https'
fs = require 'fs'
websocket = require 'websocket'
# favicon = require 'serve-favicon'
morgan = require 'morgan'
errorhandler = require 'errorhandler'

app = express()
router = express.Router()

# App settings
app.set 'port', 3000
app.use express.static path.join __dirname, 'public'
# app.use favicon()
app.use morgan 'dev'

env = process.env.NODE_ENV || 'development'
if env == 'development'
    app.use errorhandler()

# Routes
app.get '/api/notifications', routes.api.notifications

# Server
options = {
    key: fs.readFileSync('ssl/harmony-server.key')
    cert: fs.readFileSync('ssl/harmony-server.crt')
    ca: fs.readFileSync('ssl/harmony-ca.crt')
    requestCert: true
    rejectUnauthorized: false
}

server = https.createServer(options, app).listen app.get('port'), ->
    console.log("Express server listening on port #{app.get('port')}")
    return

# WebSockets
wsServer = new websocket.server {
    httpServer: server
}

wsServer.on 'request', (request) ->
    console.log request
    connection = request.accept null, request.origin
    
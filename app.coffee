express = require 'express'
routes = require './routes'
path = require 'path'
https = require 'https'
fs = require 'fs'
websocket = require 'websocket'
# favicon = require 'serve-favicon'
morgan = require 'morgan'
bodyparser = require 'body-parser'
errorhandler = require 'errorhandler'
expressjwt = require 'express-jwt'
jwt = require 'jsonwebtoken'
tokenManager = require './tokenmanager'

app = express()

# App settings
app.set 'port', 3000
app.use express.static path.join __dirname, 'public'
# app.use favicon()
app.use morgan 'dev'

# Token management
tokenManager.tm.secret = fs.readFileSync('ssl/harmony-server-key.pub')

app.use '/api', expressjwt({secret: tokenManager.tm.secret})
app.use bodyparser.json()
app.use bodyparser.urlencoded({extended: false})

env = process.env.NODE_ENV || 'development'
if env == 'development'
    app.use errorhandler()

# Routes
app.post '/authenticate', (req, res) ->
    authCode = req.body["password"]
    if authCode != "pass"
        res.status(401).send('Wrong authentification code')
        return
    token = tokenManager.tm.generateToken authCode, jwt
    res.json {'token': token}
    return

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
    token = request.resourceURL.path.replace(/^\//, "")
    if tokenManager.tm.websocketAddable token
        websocket = request.accept null, request.origin
        tokenManager.tm.addWebSocket token, websocket
    else
        request.reject 403

wsServer.on 'connect', (connection) ->
    
    
express = require('express')
routes = require('./routes/routes')
path = require('path')
https = require('https')
fs = require('fs')
websocket = require('websocket')

app = express()
router = express.Router()

app.configure ->
    app.set 'port', 3000
    app.use express.favicon()
    app.use express.logger 'dev'
    app.use app.router
    app.use express.static path.join(__dirname, 'public')
    return

app.configure 'development', ->
    app.use express.errorHandler()
    return

app.get '/api/notifications', routes.api.notifications

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
    
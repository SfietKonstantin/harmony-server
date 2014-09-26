express = require('express')
routes = require('./routes/routes')
path = require('path')
http = require('http')

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
    
http.createServer(app).listen app.get('port'), ->
    console.log("Express server listening on port #{app.get('port')}")
    return

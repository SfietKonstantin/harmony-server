root = exports ? this
root.api = {}

root.api.notifications = (req, res) ->
    notifications = {
        test: "Hello world !"
    }
    res.json(notifications)
    

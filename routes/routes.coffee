root = exports ? this
root.api = {}

root.api.notifications = (req, res) ->
    notifications = [
        {
            id: "1"
            title: "test 1"
        },
        {
            id: "2"
            title: "test 2"
        },
        {
            id: "3"
            title: "test 3"
        },
        {
            id: "4"
            title: "test 4"
        },
        {
            id: "5"
            title: "test 5"
        },
        {
            id: "6"
            title: "test 6"
        },
        {
            id: "7"
            title: "test 7"
        }
    ]
    res.json(notifications)
    

root = exports ? this
class root.HomeView extends root.View
    el: "#content"
    template: "home"

    initialize: =>
        @notifications = new NotificationListView()
        return

    render: =>
        @doAsyncRenderTree {'#notifications-container': @notifications}
        @
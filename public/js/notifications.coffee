root = exports ? this
class root.NotificationsView extends root.View
    el: "#content"
    template: "notifications"

    initialize: =>
        @notifications = new NotificationListView()
        return

    refresh: =>
        @notifications.refresh()

    render: =>
        @doAsyncRenderTree {'#notifications-container': @notifications}
        @
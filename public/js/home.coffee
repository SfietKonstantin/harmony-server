root = exports ? this
class root.HomeView extends root.View
    el: "#content"
    template: "home"

    initialize: =>
        @test = new NotificationCollection([{title: "test 1"}, {title: "test 2"}, {title: "test 3"}, {title: "test 4"}, {title: "test 5"}, {title: "test 6"}, {title: "test 7"}, {title: "test 8"}])
        @notifications = new NotificationsView({collection: @test})
        return

    render: =>
        @doAsyncRenderTree {'#notifications-container': @notifications}
        @
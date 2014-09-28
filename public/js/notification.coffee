root = exports ? this
class root.NotificationModel extends Backbone.Model
    defaults:
        href: ""
        title: ""
        body: ""

class root.NotificationCollection extends Backbone.Collection
    model: root.NotificationModel

class root.NotificationView extends root.View
    template: "notification"
    render: =>
        @doAsyncAppend @model.toJSON()
        @

class root.NotificationsView extends root.View
    template: "notifications"
    initialize: =>
        # @collection = new root.NotificationCollection
        return
    render: =>
        @doAsyncRenderCollection "#notifications", @collection, NotificationView
        @

root = exports ? this
class root.NotificationModel extends Backbone.Model
    defaults:
        id: ""
        title: ""
        body: ""

class root.NotificationCollection extends Backbone.Collection
    model: root.NotificationModel

class root.NotificationView extends root.View
    template: "notification"
    render: =>
        @doAsyncAppend @model.toJSON()
        @

class root.NotificationListView extends root.View
    template: "notification-list"
    loading: false
    initialize: =>
        @collection = new root.NotificationCollection
        
        # Get the notifications from API
        $.ajax {
            url: "api/notifications"
            success: (data) =>
                @_parseReply data
            dataType: 'json'
        }
        return
    render: =>
        @doAsyncRenderCollection "#notifications", @collection, NotificationView
        @
        
    _parseReply: (data) =>
        for notification in data
            model = new NotificationModel(notification)
            @collection.push model
        @render

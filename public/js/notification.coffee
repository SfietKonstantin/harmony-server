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
    state: ""
    initialize: =>
        @collection = new root.NotificationCollection
        return

    refresh: =>
        @state = "loading"
        @render()
        # Get the notifications from API
        $.ajax {
            url: "api/notifications"
            success: (data, textStatus, jqXHR) =>
                @_parseReply data
                @state = "success"
                @render()
            error: (jqXHR, textStatus, errorThrown) =>
                @state = "error"
                @render()
            dataType: 'json'
            headers: {
                Authorization: 'Bearer ' + root.loginManager.token
            }
        }
        return
    render: =>
        switch @state
            when "loading" 
                console.log "NotificationListView: Loading"
            when "success" 
                console.log "NotificationListView: Success"
                @doAsyncRenderCollection "#notifications", @collection, NotificationView
            when "error" 
                console.log "NotificationListView: Error"
            else
                console.log "NotificationListView: Unknown"
        @
        
    _parseReply: (data) =>
        for notification in data
            model = new NotificationModel(notification)
            @collection.push model

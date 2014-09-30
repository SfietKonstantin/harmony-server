root = exports ? this
class TemplateManager
    templates: {}
    deferreds: {}

    _loadTemplateDeferred: (template) =>
        console.debug "Downloading template: #{template}"
        $.ajax {
            url: "tpl/#{template}.html"
            success: (data) =>
                @templates[template] = data
            dataType: 'html'
        }

    asyncGetTemplate: (template, callback) =>
        if template of @templates
            callback()
            return
        if template not of @deferreds
            @deferreds[template] = @_loadTemplateDeferred template
        @deferreds[template].then =>
            callback()
            delete @deferreds[template]
        return 

class root.View extends Backbone.View
    template: ""
    doAsyncRender: (args) =>
        @_doAsyncCallback =>
            @_doRender @template, args

    doAsyncAppend: (args) =>
        @_doAsyncCallback =>
            @_doAppend @template, args

    doAsyncRenderTree: (subviews, args) =>
        @_doAsyncCallback =>
            @_doRender @template, args
            for selector of subviews
                subview = subviews[selector]
                subview.setElement(@.$(selector)).render()

    doAsyncRenderCollection: (selector, collection, ViewClass, args) =>
        subviewList = []
        collection.each (model) ->
            subview = new ViewClass({model: model})
            if not template?
                template = subview.template
            subviewList.push subview
        @_doAsyncCallback =>
            @_doRender @template, args
            for subview in subviewList
                subview.setElement(@.$(selector)).render()

    _doAsyncCallback: (callback) =>
        if not root.templateManager?
            console.warn "AsyncRender when templateManager not available"
            return
        root.templateManager.asyncGetTemplate @template, -> 
            callback()
        @

    _doRender: (template, args) =>
        if not root.templateManager?
            console.warn "Render when templateManager not available"
            return
        if template not of root.templateManager.templates
            console.warn "Template #{template} is not cached"
            return
        compiled = _.template root.templateManager.templates[template]
        $(@el).html compiled(args)
        @
    _doAppend: (template, args) =>
        if not root.templateManager?
            console.warn "Render when templateManager not available"
            return
        if template not of root.templateManager.templates
            console.warn "Template #{template} is not cached"
            return
        compiled = _.template root.templateManager.templates[template]
        $(@el).append compiled(args)
        @

class ApplicationRouter extends Backbone.Router
    routes: {
        "": "home"
        "settings": "settings"
        "notifications": "notifications"
        "notifications/:id": "notifications"
        "*actions": "home"
    }

    initialize: =>
        @headerView = new HeaderView()
        @footerView = new FooterView()
        return

    initialRender: =>
        @headerView.render()
        @footerView.render()
        return

    home: =>
        if not @homeView
            @homeView = new HomeView()
        @homeView.render()
        return
    settings: =>
        if not @settingsView
            @settingsView = new SettingsView()
        @settingsView.render()
        return
    notifications: =>
        if not @notificationsView
            @notificationsView = new NotificationsView()
        @notificationsView.render()
        return

root.templateManager = new TemplateManager()
root.connection = new root.WebSocket 'wss://localhost:3000'
root.connection.onopen = ->
    console.debug "OPENED"

jQuery ->
    app = new ApplicationRouter()
    app.initialRender()
    app.on "route", (route, params) ->
        app.headerView.activate(route)
    Backbone.history.start()

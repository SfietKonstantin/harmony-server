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
        if @onRenderFinished?
            @onRenderFinished()
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

class root.LoginManager
    token = null
    ws = null

    login: (data) =>
        $.post "/authenticate", data, (data) =>
            if "token" of data
                @token = data.token
                @connectWs()
                root.app.shellRender()
                root.app.navigate "", {trigger: true}
            else
                # Redirect to error
    connectWs: =>
        if @token?
            console.log "Connecting websocket to wss://#{root.location.host}/#{@token}"
            @ws = new root.WebSocket "wss://#{root.location.host}/#{@token}"
            @ws.onopen = ->
                console.log "Websocket connected"

class root.ApplicationRouter extends Backbone.Router
    routes: {
        "": "home"
        "login": "login"
        "settings": "settings"
        "notifications": "notifications"
        "notifications/:id": "notifications"
        "*actions": "home"
    }

    shellRender: =>
        if !root.loginManager.token?
            @loginRender()
        else
            @mainRender()

    loginRender: =>
        if not @loginHeaderView
            @loginHeaderView = new LoginHeaderView()
        @loginHeaderView.render()
        if not @footerView
            @footerView = new FooterView()
        @footerView.render()

    mainRender: =>
        if not @headerView
            @headerView = new HeaderView()
        @headerView.render()
        if not @footerView
            @footerView = new FooterView()
        @footerView.render()
        return

    login: =>
        if not @loginView
            @loginView = new LoginView()
        @loginView.render()

    navigateLogin: =>
        if !root.loginManager.token?
            @navigate "login", {trigger: true}
            return true
        return false

    home: =>
        if not @homeView
            @homeView = new HomeView()
        if not @navigateLogin()
            @homeView.refresh()
            @homeView.render()
        return
    settings: =>
        if not @settingsView
            @settingsView = new SettingsView()
        if not @navigateLogin()
            @settingsView.render()
        return
    notifications: =>
        if not @notificationsView
            @notificationsView = new NotificationsView()
        if not @navigateLogin()
            @notificationsView.refresh()
            @notificationsView.render()
        return

root.templateManager = new TemplateManager()
root.loginManager = new LoginManager()
root.app = new ApplicationRouter()

jQuery ->
    app.shellRender()
    app.on "route", (route, params) ->
        if app.headerView?
            app.headerView.activate(route)
    Backbone.history.start()

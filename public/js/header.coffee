root = exports ? this
class root.HeaderView extends root.View
    el: "#header"
    template: "header"
    current: ""
    active: {
        homeactive: ""
        settingsactive: ""
        notificationsactive: ""
    }

    activate: (page) =>
        if page == @current
            return
        for key of @active
            @active[key] = ""
        @active["#{page}active"] = "class='active'"
        @current = page
        @render()

    render: =>
        @doAsyncRender @active
        @
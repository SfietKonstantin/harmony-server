root = exports ? this
class root.SettingsView extends root.View
    el: "#content"
    template: "settings"

    render: =>
        @doAsyncRender()
        @

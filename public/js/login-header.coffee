root = exports ? this
class root.LoginHeaderView extends root.View
    el: "#header"
    template: "login-header"

    render: =>
        @doAsyncRender()
        @
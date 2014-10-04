root = exports ? this
class root.LoginView extends root.View
    el: "#content"
    template: "login"
    render: =>
        @doAsyncRender()
        @
    onRenderFinished: =>
        $("#signin-button").bind "click", ->
            password = $("#signin-password").val()
            loginManager.login "password=#{password}"
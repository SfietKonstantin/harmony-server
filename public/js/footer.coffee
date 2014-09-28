root = exports ? this
class root.FooterView extends root.View
    el: "#footer"
    template: "footer"

    render: =>
        @doAsyncRender()
        @
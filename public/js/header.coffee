root = exports ? this
class root.HeaderView extends Backbone.View
	el: "#header"
	
	current: ""
	active: {
		homeactive: ""
		settingsactive: ""
		notificationsactive: ""
	}
	
	activate: (page) ->
		if page == @current
			return
		for key of @active
			@active[key] = ""
		@active["#{page}active"] = "class='active'"
		@current = page
		@render()
		
	render: -> 
		root.templateManager.asyncRender(@, 'header', @active)
		@
root = exports ? this
class root.SettingsView extends Backbone.View
	el: "#content"
	render: -> 
		root.templateManager.asyncRender(@, 'settings')

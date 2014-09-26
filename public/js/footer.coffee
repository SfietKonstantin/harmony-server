root = exports ? this
class root.FooterView extends Backbone.View
	el: "#footer"
	
	render: -> 
		root.templateManager.asyncRender(@, 'footer')
		@
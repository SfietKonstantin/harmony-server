root = exports ? this
class root.HomeView extends Backbone.View
	el: "#content"
	initialize: ->
		@test = new NotificationCollection([{title: "test 1"}, {title: "test 2"}])
	
		@notifications = new NotificationsView({collection: @test})
		return
	
	render: -> 
		root.templateManager.asyncRenderTree(@, 'home', {'#notifications-container': @notifications})
		@
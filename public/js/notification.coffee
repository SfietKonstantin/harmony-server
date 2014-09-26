root = exports ? this
class root.NotificationModel extends Backbone.Model
	defaults:
		href: ""
		title: ""
		body: ""
	
class root.NotificationCollection extends Backbone.Collection
	model: root.NotificationModel

class root.NotificationView extends Backbone.View
	render: ->
		templateManager.asyncAppend(@, 'notification', @model.toJSON())
		@
		
class root.NotificationsView extends Backbone.View
	initialize: ->
		# @collection = new root.NotificationCollection
		return
	render: -> 
		#root.templateManager.asyncRenderWithCallback @, 'notifications', =>
		#	@collection.each (notification) =>
		#		notificationView = new NotificationView({model: notification})
		#		@.$("#notifications").append(notificationView.render().el)
		root.templateManager.asyncRenderCollection(@, 'notifications', '#notifications', @collection, NotificationView)
		@

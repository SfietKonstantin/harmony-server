root = exports ? this
class TemplateManager
	templates: {}
	render: (view, template, args) ->
		if template not of @templates
			console.warn("Template #{template} not cached")
			return
		compiled = _.template(@templates[template])
		$(view.el).html(compiled(args))
		
	append: (view, template, args) ->
		if template not of @templates
			console.warn("Template #{template} not cached")
			return
		compiled = _.template(@templates[template])
		$(view.el).append(compiled(args))
	
	asyncGetTemplate: (template, callback) ->
		if template not of @templates
			@loadTemplates([template], callback)
		else
			callback()
			
	asyncRender: (view, template, args) ->
		@asyncGetTemplate template, => 
			@render(view, template, args)
	
	asyncAppend: (view, template, args) ->
		@asyncGetTemplate template, => 
			@append(view, template, args)
	
	asyncRenderTree: (view, template, subviews, args) ->
		@asyncGetTemplate template, => 
			@render(view, template, args)
			for selector of subviews
				subview = subviews[selector]
				subview.setElement(view.$(selector)).render()
	
	asyncRenderCollection: (view, template, selector, collection, View, args) ->
		@asyncGetTemplate template, => 
			@render(view, template, args)
			collection.each (model) =>
				subview = new View({model: model})
				subview.setElement(view.$(selector)).render()
				
	asyncRenderWithCallback: (view, template, callback, args) ->
		@asyncGetTemplate template, => 
			@render(view, template, args)
			callback()
			
	loadTemplates: (templates, callback) ->
		# Templates might load several times :(
		# Better deferred code needed
		deferreds = []
		for template in templates
			result = $.ajax {
				url: "tpl/#{template}.html"
				success: (data) => 
					@templates[template] = data
				dataType: 'html'
			}
			deferreds.push(result)
		$.when.apply(null, deferreds).done(callback)

class ApplicationRouter extends Backbone.Router
	routes: {
		"": "home"
		"settings": "settings"
		"notifications": "notifications"
		"*actions": "home"
	}

	initialize: ->
		@headerView = new HeaderView()
		@footerView = new FooterView()
		return
		
	initialRender: ->
		@headerView.render()
		@footerView.render()
		return
	
	home: ->
		if not @homeView
			@homeView = new HomeView()
		@homeView.render()
		return
	settings: ->
		if not @settingsView
			@settingsView = new SettingsView()
		@settingsView.render()
		return

root.templateManager = new TemplateManager()
jQuery ->
	app = new ApplicationRouter()
	app.initialRender()
	app.on "route", (route, params) ->
		app.headerView.activate(route)
	Backbone.history.start()

class App.Views.Project extends Backbone.View
	template: HandlebarsTemplates['app/templates/project']

	events: 
		"click a":"showDetails"

	showDetails: (e) ->
		e.preventDefault()
		App.Vent.trigger "project:show", @model
		Backbone.history.navigate "/projects/" + @model.id

	render: ->
		@$el.html(@template(@model.toJSON()))
		@

class App.Views.ProjectDetails extends Backbone.View
	template: HandlebarsTemplates['app/templates/project_details']


	initialize: ->
		@model.fetch()
		@listenTo @model, "sync", @render

	render: ->
		@$el.html(@template(@model.toJSON()))
		@

class App.Views.NewProjects extends Backbone.View

	template: HandlebarsTemplates['app/templates/new_project']

	events:
		"click button" : "saveProject"

	initialize: ->
		@listenTo @model, "sync", @triggerProjectCreate

	triggerProjectCreate: ->
		App.Vent.trigger "project:create", @model

	render: ->
		@$el.html(@template())
		@

	saveProject: (e) ->
		e.preventDefault()
		@model.set name: @$("#name").val()
		@model.set description: @$('#description').val()
		@model.save()
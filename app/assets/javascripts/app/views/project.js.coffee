class App.Views.Project extends Backbone.View
	template: HandlebarsTemplates['app/templates/project']

	events: 
		"click a":"showDetails"

	initialize: ->
		@listenTo @model, 'destroy', @remove
		@listenTo @model, 'change:name', @render

	showDetails: (e) ->
		e.preventDefault()
		App.Vent.trigger "project:show", @model
		Backbone.history.navigate "/projects/" + @model.id

	render: ->
		@$el.html(@template(@model.toJSON()))
		@

class App.Views.ProjectDetails extends Backbone.View
	template: HandlebarsTemplates['app/templates/project_details']

	events: 
		"click button.destroy": "deleteProject"
		"click button.edit": 'editProject'

	editProject: ->
		App.Vent.trigger "project:edit", @model

	deleteProject: ->
		return unless confirm("Are you sure?")
		@model.destroy
			success:-> App.Vent.trigger "project:destroy"

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
		@listenTo @model, "sync", @render
		@model.fetch() unless @model.isNew()


	triggerProjectCreate: ->
		App.Vent.trigger "project:create", @model

	render: ->
		@$el.html(@template(@model.toJSON()))
		@

	saveProject: (e) ->
		e.preventDefault()
		@model.set name: @$("#name").val()
		@model.set description: @$('#description').val()
		@model.save {},
			success: (model) -> App.Vent.trigger "project:create", model
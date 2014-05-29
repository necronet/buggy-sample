class App.Views.Header extends Backbone.View

	className: "navbar navbar-default"

	template: HandlebarsTemplates['app/templates/header']

	render: ->
		@$el.html(@template())
		@
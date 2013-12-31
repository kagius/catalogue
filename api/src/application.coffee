mongoose = require "mongoose"
config = require "./config"

Catalogue = require "./catalogue"
Text = require "./text"

Controller = require "./controller"
HtmlController = require "./htmlController"

Server = require "./server"
JadeRenderer = require "./render-jade"

class Application

	constructor : (@config) ->		
		mongoose.connect(@config.db.url);
		@db = mongoose.connection;		

		@server = {}
		@model = {}
		@controllers = {}
		@renderer = {}

app = new Application config
app.server = new Server app

app.model.Catalogue = new Catalogue app
app.model.Text = new Text app

# Register renderer.
app.renderer = new JadeRenderer app

# Register controllers.
app.controllers.Hierarchy = new Controller app, "/api/:format"
app.controllers.Html = new HtmlController app, ""

# Start accepting http requests.
app.server.start()
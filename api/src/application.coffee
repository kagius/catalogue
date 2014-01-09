mongoose = require "mongoose"
config = require "./config"

Catalogue = require "./catalogue"
Text = require "./text"

CatalogueController = require "./CatalogueController"
PageController = require "./PageController"

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
app.controllers.PageApi = new PageController app, "/api", app.server.jsonWriter
app.controllers.PageWeb = new PageController app, "", app.server.htmlWriter
app.controllers.CatalogueApi = new CatalogueController app, "/api", app.server.jsonWriter
app.controllers.CatalogueWeb = new CatalogueController app, "", app.server.htmlWriter

# Start accepting http requests.
app.server.start()
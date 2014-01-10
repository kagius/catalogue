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
app.controllers.DefaultPageApi = new PageController app, "/api/:language", app.server.jsonWriter
app.controllers.DefaultPageWeb = new PageController app, "/:language", app.server.htmlWriter

app.controllers.DefaultCatalogueApi = new CatalogueController app, "/api/:language", app.server.jsonWriter
app.controllers.DefaultCatalogueWeb = new CatalogueController app, "/:language", app.server.htmlWriter

# Start accepting http requests.
app.server.start()
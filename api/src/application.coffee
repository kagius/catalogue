mongoose = require "mongoose"
config = require "./config"

Catalogue = require "./catalogue"
Text = require "./text"

CatalogueController = require "./CatalogueController"
PageController = require "./PageController"
LanguageSelectorController = require "./LanguageSelectorController"

Server = require "./server"
JadeRenderer = require "./render-jade"
Resources = require "./Resources"
Mailer = require "./mailer"

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

app.resources = new Resources app

app.model.Catalogue = new Catalogue app
app.model.Text = new Text app

# Register renderer.
app.renderer = new JadeRenderer app

# Register mail helper
app.mailer = new Mailer app

# Register controllers.
app.controllers.DefaultPageApi = new PageController app, "/api/:language", app.server.jsonWriter
app.controllers.DefaultPageWeb = new PageController app, "/:language", app.server.htmlWriter

app.controllers.DefaultCatalogueApi = new CatalogueController app, "/api/:language", app.server.jsonWriter
app.controllers.DefaultCatalogueWeb = new CatalogueController app, "/:language", app.server.htmlWriter

app.controllers.MainPageWeb = new LanguageSelectorController app, "/", app.server.htmlWriter

# Start accepting http requests.
app.server.start()
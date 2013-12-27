mongoose = require "mongoose"
config = require "./config"
Server = require "./server"
Controller = require "./controller"
Hierarchy = require "./hierarchy"
JadeRenderer = require "./render-jade"

class Application

	constructor : (@config) ->		

		mongoose.connect(@config.db.url);
		@db = mongoose.connection;		

		@server = {}
		@controllers = {}
		@renderer = {}

app = new Application config
app.server = new Server app
app.renderer = new JadeRenderer app

app.controllers.Hierarchy = new Controller app, "/api/:format"

app.server.start()
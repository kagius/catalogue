mongoose = require "mongoose"
config = require "./config"
Server = require "./server"
Controller = require "./controller"
Hierarchy = require "./hierarchy"

class Application

	constructor : (@config) ->		

		mongoose.connect(@config.db.url);
		@db = mongoose.connection;		

		@server = {}
		@controllers = {}

app = new Application config
app.server = @server = new Server app
app.controllers.Hierarchy = new Controller app, "/api/data/"

app.server.start()
mongoose = require "mongoose"
config = require "./config"
Server = require "./server"
Controller = require "./controller"
Hierarchy = require "./hierarchy"
mu = require "mu2"

class Application

	constructor : (@config) ->		

		mongoose.connect(@config.db.url);
		@db = mongoose.connection;		

		@server = {}
		@controllers = {}

		@templateEngine = mu

mu.root = config.templates.path

app = new Application config
app.server = @server = new Server app
app.controllers.Hierarchy = new Controller app, "/api/data/"

app.server.start()
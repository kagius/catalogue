restify = require "restify"

module.exports = class Server

	constructor : (@app) ->
		@server = restify.createServer()
		@server.get @app.config.assets.baseUrlPattern, restify.serveStatic { directory: @app.config.assets.basePath }

		self = @

		@start = () ->
			port = self.app.config.port
			self.server.listen port, () ->
				if self.app.config.logging.info
					console.log "Listening on port #{port}"

		@setRoute = (method, route, callback) ->
			self.server[method] route, callback

		@jsonWriter = (res, data) ->
			res.setHeader 'content-type', 'application/json'
			res.send data

		@htmlWriter = (res, data, next) ->
			body = self.app.renderer.render "layout", data
				
			res.writeHead 200, { 'Content-Type': 'text/html', 'Content-Length' : body.length }
			res.write body
			res.end()
			next()

		@generateHandler = (name, handler) ->
			return (req, res, next) ->
				if self.app.config.logging.trace
					console.log "Routing request to #{name}"
					console.log req.params

				handler.implementation req, handler, (err, data) ->
					if err
						console.log  err

					if self.app.config.headers.accessControlAllowOrigins
						res.setHeader 'Access-Control-Allow-Origin', self.app.config.headers.accessControlAllowOrigins

					handler.writer res, data, next

		@_route = (method, route, version, name, implementation) ->
			if self.app.config.logging.trace
				console.log "Registering #{method} handler #{name} for route '#{route}' v#{version}"

			self.setRoute method, { path: route, version: version }, implementation		

		@_register = (baseUrl, name, handler) ->
			handlerWrapper = self.generateHandler name, handler		
			self._route handler.method, baseUrl + route, handler.version, name, handlerWrapper for route in handler.routes

		@registerHandlers = (baseUrl, handlers) ->
			self._register baseUrl, handler.name, handler for handler in handlers
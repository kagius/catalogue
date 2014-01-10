module.exports = class PageController

	constructor : (@app, @baseUrl, @writer) ->

		self = @

		@contentNotFound = (language, handler, callback)->

			data = { _id:"404", language:language }
			self.localize data, (model)->
				model.httpStatus = 404				
				self.finalize model, { htmlTemplate: "404" }, callback

		@localize = (data, callback) ->

			model = { 
				data: data, 
				language: data.language,
				url: data._id
			}

			self.app.model.Text.find (err, text) ->
				model.meta = text.meta
				model.meta.url = self.app.config.globals.baseUrl + "/" + data._id
				model.content = text.content

				callback model

			, data._id, model.language

		@finalize = (model, handler, callback) ->
			response = {
				meta: model.meta
				url: self.app.config.globals.baseUrl + "/" + model.url
				content: self.app.renderer.render handler.htmlTemplate, model
			}

			callback null, response

		@handlers = [
			{
				name: "about",
				method: "get",
				routes: [ "/about" ],
				version: "1.0.0",
				htmlTemplate: "about-page",
				writer: self.writer,
				implementation: (req, handler, callback) -> 
					data = { _id: "page/about", language: req.params.language }

					self.localize data, (model) ->
						self.finalize model, handler, callback
			},

			{
				name: "contact",
				method: "get",
				routes: [ "/contact" ],
				version: "1.0.0",
				htmlTemplate: "contact-page",
				writer: self.writer,
				implementation: (req, handler, callback) -> 
					data = { _id: "page/contact", language: req.params.language }

					self.localize data, (model) ->
						self.finalize model, handler, callback
			},

			{
				name: "doContact",
				method: "post",
				routes: [ "/contact" ],
				version: "1.0.0",
				htmlTemplate: "contact-page",
				writer: self.writer,
				implementation: (req, handler, callback) -> 
					data = { _id: "page/contact", language: req.params.language }

					self.localize data, (model) ->
						self.finalize model, handler, callback
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
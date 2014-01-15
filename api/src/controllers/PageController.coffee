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

			self.app.model.Text.find data._id, model.language, (text) ->
				model.meta = text.meta
				model.content = text.content
				model.meta.url = self.app.config.globals.baseUrl + "/" + data.language + "/" + data.slug
				model.meta._id = data._id
				model.url = data.slug

				callback model

		@finalize = (model, handler, callback) ->
			model.i18n = self.app.resources.get(model.language)

			response = {
				meta: model.meta
				url: model.meta.url,
				path: model.url,
				content: self.app.renderer.render(handler.htmlTemplate, model),
				language: model.language
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
					data = { _id: "page/about", language: req.params.language, slug: "about"}

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
					data = { _id: "page/contact", language: req.params.language, slug: "contact" }

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
					self.app.mailer.send req.params.address, req.params.subject, req.params.message, (mailResponse) ->
						data = { _id: "page/contact", language: req.params.language, slug: "contact" }

						self.localize data, (model) ->
							model.sendSuccess = mailResponse.success
							model.sendFail = !mailResponse.success
							
							self.finalize model, handler, callback
			},
		]

		@app.server.registerHandlers baseUrl, @handlers
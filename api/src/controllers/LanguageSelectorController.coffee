module.exports = class LanguageSelectorController

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
				model.meta.url = self.app.config.globals.baseUrl + "/" + data._id
				model.content = text.content

				callback model

		@finalize = (model, handler, callback) ->
			response = {
				meta: model.meta
				url: self.app.config.globals.baseUrl + "/" + model.url
				content: self.app.renderer.render handler.htmlTemplate, model
			}

			callback null, response

		@handlers = [
			{
				name: "selectLanguage",
				method: "get",
				routes: [ "" ],
				version: "1.0.0",
				htmlTemplate: "select-language-page",
				writer: self.writer,
				implementation: (req, handler, callback) -> 
					data = { _id: "page/select-language", language: "en" }

					self.localize data, (model) ->
						model.meta.nolinks = true
						self.finalize model, handler, callback
			},
		]

		@app.server.registerHandlers baseUrl, @handlers
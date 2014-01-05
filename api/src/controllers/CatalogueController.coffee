module.exports = class CatalogueController

	constructor : (@app, @baseUrl, @writer) ->

		self = @

		@contentNotFound = (language, handler, callback)->

			data = { _id:"404", language:language }
			self.localize data, (model)->
				model.httpStatus = 404				
				self.finalize model, { htmlTemplate: "404" }, callback

		@query = (req, callback) ->
			self.app.model.Catalogue.find callback, req.params.country, req.params.location, req.params.site, req.params.exhibit

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

		@localizeChildCollection = (model, childCollectionName, callback) ->
			self.app.model.Text.getTitles (err, list) ->
				model.children = list
				callback model
			, model.data[childCollectionName], model.language

		@addLocalizedParameter = (model, parameterName, parameterValue, callback) ->
			self.app.model.Text.find (err, text) ->
				model[parameterName] = { label: text.meta.title, url: text.url }
				callback model
			, parameterValue, model.language

		@finalize = (model, handler, callback) ->
			response = {
				meta: model.meta
				url: self.app.config.globals.baseUrl + "/" + model.url
				content: self.app.renderer.render handler.htmlTemplate, model
			}

			if (model.data.type)
				response.meta.type = model.data.type

			callback null, response

		@handlers = [
			{
				name: "exhibit",
				method: "get",
				routes: [ "/:country/:location/:site/:exhibit" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-detail",
				writer: self.writer,
				implementation: (req, handler, callback) -> 

					self.query req, (err, data) ->

						if !data
							self.contentNotFound "en", handler, callback
							return

						data.language = "en"

						countryUrl = req.params.country.toLowerCase()
						locationUrl = countryUrl + "/" + req.params.location.toLowerCase()
						siteUrl = locationUrl + "/" + req.params.site.toLowerCase()

						self.localize data, (model) ->
							self.addLocalizedParameter model, "country", countryUrl, (model) ->								
								self.addLocalizedParameter model, "locality", locationUrl, (model) ->
									self.addLocalizedParameter model, "site", siteUrl, (model) ->
										self.finalize model, handler, callback
			},

			{
				name: "exhibitsInSite",
				method: "get",
				routes: [ "/:country/:location/:site" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-list",
				writer: self.writer,
				implementation: (req, handler, callback) -> 

					self.query req, (err, data) ->

						if !data
							self.contentNotFound "en", handler, callback
							return

						data.language = "en"
						countryUrl = req.params.country.toLowerCase()
						locationUrl = countryUrl + "/" + req.params.location.toLowerCase()

						self.localize data, (model) ->
							self.localizeChildCollection model, "exhibits", (model) ->
								self.addLocalizedParameter model, "country", countryUrl, (model) ->								
									self.addLocalizedParameter model, "locality", locationUrl, (model) ->							
										self.finalize model, handler, callback
			},

			{
				name: "sitesInLocation",
				method: "get",
				routes: [ "/:country/:location" ],
				version: "1.0.0",
				htmlTemplate: "site-list",
				writer: self.writer,
				implementation: (req, handler, callback) -> 

					self.query req, (err, data) ->

						if !data
							self.contentNotFound "en", handler, callback
							return

						data.language = "en"
						self.localize data, (model) ->
							self.localizeChildCollection model, "sites", (model) ->
								self.addLocalizedParameter model, "country", req.params.country.toLowerCase(), (model) ->				
									self.finalize model, handler, callback
			},

			{
				name: "locationsInCountry",
				method: "get",
				routes: [ "/:country" ],
				version: "1.0.0",
				htmlTemplate: "location-list",
				writer: self.writer,
				implementation: (req, handler, callback) -> 

					self.query req, (err, data) ->
						
						if !data
							self.contentNotFound "en", handler, callback
							return

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "localities", (model) ->
								self.finalize model, handler, callback					
			},

			{
				name: "allCountries",
				method: "get",
				routes: ["/"],
				version: "1.0.0",
				htmlTemplate: "country-list",
				writer: self.writer,
				implementation: (req, handler, callback) -> 
					self.query req, (err, data) ->

						if !data
							self.contentNotFound "en", handler, callback
							return

						data.language = "en"
						data._id = ""
						
						self.localize data, (model) ->

							countries = []
							countries.push(item.id) for item in model.data

							self.app.model.Text.getTitles (err, list) ->
								model.children = list								
								self.finalize model, handler, callback
							, countries, data.language
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
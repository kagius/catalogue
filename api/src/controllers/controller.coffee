module.exports = class HtmlController

	constructor : (@app, @baseUrl) ->

		self = @

		@query = (req, callback) ->
			self.app.model.Catalogue.find callback, req.params.country, req.params.location, req.params.site, req.params.exhibit

		@localize = (data, callback) ->

			model = {}
			model.data = data
			model.language = data.language

			self.app.model.Text.find (err, text) ->
				model.meta = text.meta
				model.meta.url = self.app.config.globals.baseUrl + "/" + data._id
				model.url = data._id
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
				model[parameterName] = {}
				model[parameterName].label = text.meta.title
				model[parameterName].url = text.url

				callback model
			, parameterValue, model.language

		@handlers = [
			{
				name: "exhibit",
				method: "get",
				routes: [ "/:country/:location/:site/:exhibit" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-detail",
				implementation: self.query
			},

			{
				name: "exhibitsInSite",
				method: "get",
				routes: [ "/:country/:location/:site" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-list",
				implementation: (req, callback) -> 

					self.query req, (err, data) ->

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "exhibits", (model) ->
								self.addLocalizedParameter model, "country", req.params.country.toLowerCase(), (model) ->								
									self.addLocalizedParameter model, "locality", req.params.country.toLowerCase() + "/" + req.params.location.toLowerCase(), (model) ->								
										# Build the response model.
										response = {}
										response.meta = model.meta
										response.url = self.app.config.globals.baseUrl + "/" + model.url
										response.content = self.app.renderer.render "exhibit-list", model

										callback null, response
			},

			{
				name: "sitesInLocation",
				method: "get",
				routes: [ "/:country/:location" ],
				version: "1.0.0",
				htmlTemplate: "site-list",
				implementation: (req, callback) -> 

					self.query req, (err, data) ->

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "sites", (model) ->
								self.addLocalizedParameter model, "country", req.params.country.toLowerCase(), (model) ->				
									# Build the response model.
									response = {}
									response.meta = model.meta
									response.url = self.app.config.globals.baseUrl + "/" + model.url
									response.content = self.app.renderer.render "site-list", model

									callback null, response
			},

			{
				name: "locationsInCountry",
				method: "get",
				routes: [ "/:country" ],
				version: "1.0.0",
				htmlTemplate: "location-list",
				implementation: (req, callback) -> 

					self.query req, (err, data) ->

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "localities", (model) ->
								# Build the response model.
								response = {}
								response.meta = model.meta
								response.url = self.app.config.globals.baseUrl + "/" + model.url
								response.content = self.app.renderer.render "location-list", model

								callback null, response						
			},

			{
				name: "allCountries",
				method: "get",
				routes: ["/"],
				version: "1.0.0",
				htmlTemplate: "country-list",
				implementation: (req, callback) -> 
					self.query req, (err, data) ->

						data.language = "en"
						data._id = ""
						
						self.localize data, (model) ->

							countries = []
							countries.push(item.id) for item in model.data

							self.app.model.Text.getTitles (err, list) ->
								model.children = list								

								# Build the response model.
								response = {}
								response.meta = model.meta
								response.url = self.app.config.globals.baseUrl + "/" + model.url
								response.content = self.app.renderer.render "country-list", model

								callback null, response

							, countries, "en"							
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
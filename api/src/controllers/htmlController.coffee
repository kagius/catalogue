module.exports = class HtmlController

	constructor : (@app, @baseUrl) ->

		self = @

		@query = (req, callback) ->
			self.app.model.Catalogue.find callback, req.params.country, req.params.location, req.params.site, req.params.exhibit

		@localize = (data, callback) ->

			model = {}
			model.data = data
			model.language = data.language

			console.log model

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
				htmlTemplate: "exhibit-detail-wrapper",
				implementation: self.query
			},

			{
				name: "exhibitsInSite",
				method: "get",
				routes: [ "/:country/:location/:site" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-list-wrapper",
				implementation: (req, callback) -> 

					self.query req, (err, data) ->

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "exhibits", (model) ->
								self.addLocalizedParameter model, "country", req.params.country.toLowerCase(), (model) ->								
									self.addLocalizedParameter model, "locality", req.params.country.toLowerCase() + "/" + req.params.location.toLowerCase(), (model) ->								
										callback null, model
			},

			{
				name: "sitesInLocation",
				method: "get",
				routes: [ "/:country/:location" ],
				version: "1.0.0",
				htmlTemplate: "site-list-wrapper",
				implementation: (req, callback) -> 

					self.query req, (err, data) ->

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "sites", (model) ->
								self.addLocalizedParameter model, "country", req.params.country.toLowerCase(), (model) ->	
									console.log model							
									callback null, model
			},

			{
				name: "locationsInCountry",
				method: "get",
				routes: [ "/:country" ],
				version: "1.0.0",
				htmlTemplate: "location-list-wrapper",
				implementation: (req, callback) -> 

					self.query req, (err, data) ->

						data.language = "en"

						self.localize data, (model) ->
							self.localizeChildCollection model, "localities", (model) ->
								callback null, model							
			},

			{
				name: "allCountries",
				method: "get",
				routes: ["/"],
				version: "1.0.0",
				htmlTemplate: "country-list-wrapper",
				implementation: (req, callback) -> 
					self.query req, (err, data) ->

						data.language = "en"
						data._id = ""
						
						self.localize data, (model) ->

							countries = []
							countries.push(item.id) for item in model.data

							self.app.model.Text.getTitles (err, list) ->
								model.children = list
								callback err, model
							, countries, "en"							
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
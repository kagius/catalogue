module.exports = class Controller

	constructor : (@app, @baseUrl) ->
		self = this

		@implementation = (req, callback) ->
			self.app.model.Catalogue.find callback, req.params.country, req.params.location, req.params.site, req.params.exhibit

		@handlers = [
			{
				name: "exhibit",
				method: "get",
				routes: [ "/:country/:location/:site/:exhibit" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-detail",
				implementation: self.implementation
			},

			{
				name: "site",
				method: "get",
				routes: [ "/:country/:location/:site" ],
				version: "1.0.0",
				htmlTemplate: "exhibit-list",
				implementation: self.implementation
			},

			{
				name: "location",
				method: "get",
				routes: [ "/:country/:location" ],
				version: "1.0.0",
				htmlTemplate: "site-list",
				implementation: self.implementation
			},

			{
				name: "country",
				method: "get",
				routes: [ "/:country" ],
				version: "1.0.0",
				htmlTemplate: "location-list",
				implementation: (req, callback) -> 
					self.implementation req, (err, data) ->
						self.app.model.Text.find (err, text) ->
							model = {
								meta: text.meta
								url: data._id
								content: text.content
							}

							model.meta.url = self.app.config.globals.baseUrl + "/" + text.url
							self.app.model.Text.getTitles (err, list) ->
								model.children = list
								callback err, model
							, data.localities, "en"
							
						, data._id, "en"
			},

			{
				name: "allCountries",
				method: "get",
				routes: ["/"],
				version: "1.0.0",
				htmlTemplate: "country-list",
				implementation: (req, callback) -> 
					self.implementation req, (err, data) ->

						countries = []
						countries.push(item.id) for item in data

						self.app.model.Text.find (err, text) ->
							model = {
								meta: text.meta
								url: data.url
								content: text.content
							}

							model.meta.url = self.app.config.globals.baseUrl + "/"
							self.app.model.Text.getTitles (err, list) ->
								model.children = list
								callback err, model
							, countries, "en"
							
						, "/", "en"
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
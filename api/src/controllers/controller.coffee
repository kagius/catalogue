Hierarchy = require "./hierarchy"

module.exports = class Controller

	constructor : (@app, @baseUrl) ->
		@handlers = [
			{
				name: "exhibit",
				method: "get",
				routes: ["detail/:country/:location/:site/:exhibit"],
				version: "1.0.0",
				htmlTemplate: "exhibit-detail.mustache",
				implementation: (req, callback) ->
					Hierarchy						
						.aggregate()
						.match({"code" : req.params.country.toLowerCase() })
						.unwind('localities')
						.match({"localities.code" : req.params.location.toLowerCase() })
						.unwind('localities.sites')
						.match({"localities.sites.code" : req.params.site.toLowerCase() })
						.unwind('localities.sites.exhibits')
						.match({"localities.sites.exhibits.code" : req.params.exhibit.toLowerCase() })
						.project("code url localities.code localities.url localities.sites.code localities.sites.url localities.sites.exhibits")						
						.exec callback
			},

			{
				name: "exhibitsInSite",
				method: "get",
				routes: ["items/:country/:location/:site"],
				version: "1.0.0",
				htmlTemplate: "exhibit-list.mustache",
				implementation: (req, callback) ->
					Hierarchy						
						.aggregate()
						.match({"code" : req.params.country.toLowerCase() })
						.unwind('localities')
						.match({"localities.code" : req.params.location.toLowerCase() })
						.unwind('localities.sites')
						.match({"localities.sites.code" : req.params.site.toLowerCase() })
						.project("code url localities.code localities.url localities.sites.code localities.sites.url localities.sites.exhibits")
						.exec callback
			},

			{
				name: "sitesInLocation",
				method: "get",
				routes: ["sites/:country/:location"],
				version: "1.0.0",
				htmlTemplate: "site-list.mustache",
				implementation: (req, callback) ->
					Hierarchy						
						.aggregate()
						.match({"code" : req.params.country.toLowerCase() })
						.unwind('localities')
						.match({"localities.code" : req.params.location.toLowerCase() })
						.project("code url localities.code localities.url localities.sites.code localities.sites.url")
						.exec callback
			},

			{
				name: "locationsInCountry",
				method: "get",
				routes: ["loc/:country"],
				version: "1.0.0",
				htmlTemplate: "location-list.mustache",
				implementation: (req, callback) ->
					Hierarchy
						.find({"code" : req.params.country.toLowerCase() })
						.select("-_id")
						.exec callback
			},

			{
				name: "allCountries",
				method: "get",
				routes: ["ct"],
				version: "1.0.0",
				htmlTemplate: "country-list.mustache",
				implementation: (req, callback) ->					
					Hierarchy
						.find()
						.select("-_id")
						.exec callback
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
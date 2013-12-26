Hierarchy = require "./hierarchy"

module.exports = class Controller

	constructor : (@app, @baseUrl) ->
		@handlers = [
			{
				name: "exhibit",
				method: "get",
				routes: [":country/:location/:site/:exhibit"],
				version: "1.0.0",
				implementation: (req, callback) ->
					callback null, "ok"
			},

			{
				name: "exhibitsInSite",
				method: "get",
				routes: [":country/:location/:site"],
				version: "1.0.0",
				implementation: (req, callback) ->
					Hierarchy						
						.aggregate()
						.match({"code" : req.params.country.toLowerCase() })
						.unwind('localities')
						.match({"localities.code" : req.params.location.toLowerCase() })
						.unwind('localities.sites')
						.match({"localities.sites.code" : req.params.site.toLowerCase() })
						.project("code localities.code localities.sites.code localities.sites.exhibits")
						.exec callback
			},

			{
				name: "sitesInLocation",
				method: "get",
				routes: [":country/:location"],
				version: "1.0.0",
				implementation: (req, callback) ->
					Hierarchy						
						.aggregate()
						.match({"code" : req.params.country.toLowerCase() })
						.unwind('localities')
						.match({"localities.code" : req.params.location.toLowerCase() })
						.project("code localities.code localities.sites.code")
						.exec callback
			},

			{
				name: "locationsInCountry",
				method: "get",
				routes: [":country"],
				version: "1.0.0",
				implementation: (req, callback) ->
					Hierarchy
						.find({"code" : req.params.country.toLowerCase() })
						.select("-_id")
						.exec callback
			},

			{
				name: "allCountries",
				method: "get",
				routes: [""],
				version: "1.0.0",
				implementation: (req, callback) ->					
					Hierarchy
						.find()
						.select("-_id")
						.exec callback
			}
		]

		@app.server.registerHandlers baseUrl, @handlers
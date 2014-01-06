Countries = require "./schema_country"
Localities = require "./schema_locality"
Sites = require "./schema_site"
Exhibits = require "./schema_exhibit"

module.exports = class Catalogue
	constructor : (@app) ->
		self = @

		@find = (callback, country, locality, site, exhibit) ->

			return self.exhibit(callback, country, locality, site, exhibit) if exhibit?
			return self.exhibitsInSite(callback, country, locality, site) if site?
			return self.sitesInLocality(callback, country, locality) if locality?
			return self.localitiesInCountry(callback, country) if country?

			return self.allCountries(callback)

		@allCountries = (callback) ->
			Countries
				.find()
				.exec callback

		@localitiesInCountry = (callback, country) ->
			Countries
				.findById(country.toLowerCase())
				.exec callback

		@sitesInLocality = (callback, country, locality) ->
			Localities						
				.findById(country.toLowerCase() + "/" + locality.toLowerCase())
				.exec callback

		@exhibitsInSite = (callback, country, locality, site) ->
			Sites
				.findById(country.toLowerCase() + "/" + locality.toLowerCase() + "/" + site.toLowerCase())
				.exec callback

		@exhibit = (callback, country, locality, site, exhibit) ->
			Exhibits
				.findById(country.toLowerCase() + "/" + locality.toLowerCase() + "/" + site.toLowerCase() + "/" + exhibit.toLowerCase())
				.exec callback
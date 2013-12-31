Content = require "./content"

module.exports = class Text
	constructor : (@app) ->
		self = @

		@find = (callback, url, language) ->
			Content
				.findOne({ "url": url, "language.language" : language })
				.exec callback

		@getTitles = (callback, list, language) ->
			Content
				.where("url").in(list)
				.where("language.language", language)
				.exec callback
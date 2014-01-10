Content = require "./content"

module.exports = class Text
	constructor : (@app) ->
		self = @

		@find = (callback, url, language) ->
			Content
				.findOne({ "url": url, "language.language" : language })
				.select("-language -_id")
				.exec (err, text) -> 
					if !text && language != self.app.config.defaultLanguage
						self.find((err, txt)->
							if txt
								txt.meta["fallback"] = self.app.config.defaultLanguage

							callback err, txt
						, url, self.app.config.defaultLanguage)
					else	
						callback(err, text)

		@getTitles = (callback, list, language) ->
			Content
				.where("url").in(list)
				.where("language.language", language)
				.select("-language -_id -content ")
				.exec callback
Content = require "./content"

module.exports = class Text
	constructor : (@app) ->
		self = @

		# Finds the localized text for a given url.
		# If the text is not found in the given language, the default language
		# from app.config.defaultLanguage will be used instead.
		# url: The url to localize
		# language: The requested language.
		# callback(err, text): the callback to call when the text is loaded.
		# If no text is found, the callback will receive a null.
		@find = (callback, url, language) ->
			Content
				.findOne({ "url": url, "language.language" : language })
				.select("-language -_id")
				.exec (err, text) -> 
					if !text && language != self.app.config.defaultLanguage
						self.find((err, txt)->
							if txt
								txt.meta.fallback = self.app.config.defaultLanguage
								self.findAlternativeTranslations(url, language, (alternatives)->
									txt.meta.alternatives = alternatives
									callback err, txt
								)							
						, url, self.app.config.defaultLanguage)
					else
						self.findAlternativeTranslations(url, language, (alternatives)->
							text.meta.alternatives = alternatives							
							callback err, text
						)

		# Loads the headers for the given urls in the specified language.
		# list: the list of urls to localize.
		# language: the language to use.
		# callback(data): the function to call after loading.
		@getTitles = (callback, list, language) ->
			Content
				.where("url").in(list)
				.where("language.language", language)
				.select("-language -_id -content ")
				.exec callback

		# Loads a list of alternate translations for the url.
		# The given language is excluded.
		# url: The url for which alternatives will be loaded.
		# language: the language to exclude.
		# callback(data): The function to call after loading.
		@findAlternativeTranslations = (url, language, callback) ->
			Content
				.find({ "url" : url })
				.where("language.language").ne(language)
				.select("language.language")
				.exec (err, alts) ->
					alternatives = []
					alternatives.push(alt.language.language) for alt in alts
					callback alternatives
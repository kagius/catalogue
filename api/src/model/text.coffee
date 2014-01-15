Content = require "./content"

module.exports = class Text
	constructor : (@app) ->
		self = @

		# Finds the localized text for a given url.
		# If the text is not found in the given language, the default language
		# from app.config.defaultLanguage will be used instead.
		# url: The url to localize
		# language: The requested language.
		# callback(text): the callback to call when the text is loaded.
		# If no text is found, the callback will receive a null.
		@find = (url, language, callback) ->
			self.select url, language, (url, text, language) ->
				self.fallback url, text, language, (url, text, language) ->
					self.decorate url, text, language, callback															

		# Tries to load the content in the default language if the value in the 
		# stated language is not found. If an alternative is found, a value will be
		# added to the model in text.meta.fallback, specifying the default language.
		@fallback = (url, text, language, callback) ->

			if (text || language == self.app.config.defaultLanguage)
				# We either have the text, or there is no default.
				# Either way, nothing to do here.
				callback url, text, language
				return
			
			self.select url, self.app.config.defaultLanguage, (url, text, language)->
				if text
					text.meta.fallback = self.app.config.defaultLanguage
			
				callback url, text, language

		# Attach any additional information to the text
		# url: The url to localize
		# text: The text object to decorate
		# language: The requested language.
		# callback(err, text): the callback to call when the text is decorated.
		# If no text is found, the callback will receive a null.
		@decorate = (url, text, language, callback) ->
			if (!text)
				# Nothing to decorate.
				callback text
				return

			self.findAlternativeTranslations url, language, (alternatives)->
				text.meta.alternatives = alternatives							
				callback text

		# Loads the headers for the given urls in the specified language.
		# list: the list of urls to localize.
		# language: the language to use.
		# callback(data): the function to call after loading.
		@getTitles = (callback, list, language) ->
			Content
				.where("url").in(list)
				.where("language.language", language)
				.select("-language -_id -content ")
				.exec (err, values) ->
					callback values

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

		# Handles the query for the text.
		# url: The url to load.
		# language: The language to select.
		# callback(url, text, language): The callback to execute after selection.
		@select = (url, language, callback) ->
			Content
				.findOne({ "url": url, "language.language" : language })
				.select("-language -_id")
				.exec (err, text) -> 
					if err
						console.log err

					callback url, text, language	
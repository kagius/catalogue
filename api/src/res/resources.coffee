en = require "./en"
it = require "./it"

module.exports = class Resources
	constructor : (@app) ->
		self = @
		@_res = {
			"en": en,
			"it": it
		}
		@get = (lang) ->
			if self._res[lang]
				return self._res[lang]

			self._res[self.app.config.defaultLanguage]
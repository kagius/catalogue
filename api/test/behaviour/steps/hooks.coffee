wrap = require('../support/wrap.coffee').wrap

Hooks = () ->

	# Close browser after a test.
	@After "@browser", (callback) ->
		wrap @browser.chain.testComplete(), callback

module.exports = Hooks;
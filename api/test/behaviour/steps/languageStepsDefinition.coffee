module.exports = ->

	wrap = require('../support/wrap.coffee').wrap
	@World = require('../support/world.coffee').World

	@Given /^that I am on the site$/, (callback) ->
		wrap @browser
			.chain
			.session()
			.open('/about'), callback

	@When /^I click the "([^"]*)" language button$/, (languageCode, callback) ->
		wrap @browser
			.chain
			.click("//a[@data-lang='#{languageCode}']"), callback

	@Then /^the page language should be set to "([^"]*)"$/, (languageCode, callback) ->
		wrap @browser
			.chain
			.waitForPageToLoad(1000)
			.assertAttribute('//html@lang', languageCode), callback
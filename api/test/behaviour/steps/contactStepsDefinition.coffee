module.exports = ->

	wrap = require('../support/wrap.coffee').wrap
	@World = require('../support/world.coffee').World

	@Given /^that I am on the contact page$/, (callback) ->		
		wrap @browser
			.chain
			.session()
			.open('/contact'), callback

	@Given /^I have not provided an email address$/, (callback) ->
		wrap @browser
			.chain
			.type("address", ""), callback

	@Given /^I have not provided a message$/, (callback) ->
		wrap @browser
			.chain
			.type("message", ""), callback

	@When /^I click the send button$/, (callback) ->
		wrap @browser
			.chain
			.click("send"), callback

	@Given /^I have provided a message$/, (callback) ->
		wrap @browser
			.chain
			.type("message", "Hi! This is a test message. It's a bit padded cos there's a 50 character minimum."), callback

	@Given /^I have provided an invalid email address$/, (callback) ->
		wrap @browser
			.chain
			.type("address", "franrglezbarg.com"), callback

	@Given /^I have provided an email address$/, (callback) ->
		wrap @browser
			.chain
			.type("address", "test.ka@yopmail.com"), callback

	@Given /^I have provided a very long message$/, (callback) ->
		wrap @browser
			.chain
			.type("message", "This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters.This is a very long message. We're using it to bump the message size over 1000 characters."), callback

	@Given /^I have provided a very short message$/, (callback) ->
		wrap @browser
			.chain
			.type("message", "This is a short message."), callback

	@Then /^I get an error notification saying "([^"]*)"$/, (message, callback) ->
		wrap @browser
			.chain
			.assertTextPresent(message), callback

	@Then /^I get a success notification$/, (callback) ->
		wrap @browser
			.chain
			.waitForElementPresent("css=.alert.alert-success")
			.assertTextPresent("Thank you for your message! Your email has been sent."), callback
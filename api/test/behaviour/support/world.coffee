# Ref: http://paulbjensen.co.uk/posts/2012/07/24/testing-socketstream-apps-with-cucumber
launch = require 'selenium-launcher'
soda = require 'soda'

World = (callback) ->
	process.env["SS_ENV"] = 'cucumber'
	
	launch (err, selenium) =>
		@browser = soda.createClient
			host: selenium.host
			port: selenium.port
			url: 'http://localhost/'
			browser: 'firefox'

		callback {@browser}
		
		process.on 'exit', () -> 
			selenium.kill()

exports.World = World
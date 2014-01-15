nodemailer = require "nodemailer"

module.exports = class Mailer
	constructor: (@app) ->
		self = @

		@send = (from, message, callback) ->
			transport = nodemailer.createTransport self.app.config.mail.transport.type, self.app.config.mail.transport.options

			console.log "mailer"
			console.log from
			console.log message

			mailOptions = {
				to: self.app.config.mail.recipient,
				subject: "Message from TBD sent by: #{from}",
				text: "Sender: #{from}\n\nMessage: #{message}"
			}

			transport.sendMail mailOptions, (error, responseStatus) ->
				if (error)
					console.log error
				else
					if (self.app.config.logging.trace)
						console.log responseStatus.message
						console.log responseStatus.messageId

				callback { success: !error }
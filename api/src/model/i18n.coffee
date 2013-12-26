mongoose = require 'mongoose'

module.exports = mongoose.model 'I18n', new mongoose.Schema {
	id: String,
	locale: String,
	code: String,
	type: String,
	value: String
}
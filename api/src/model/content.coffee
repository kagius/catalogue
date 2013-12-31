mongoose = require 'mongoose'

module.exports = mongoose.model 'content', new mongoose.Schema {
	
	url : String,
	
	language: {
		country: String,
		locale: String,
		language : String
	},
	
	meta: {
		title: String,
		description: String,
		keywords: String,	
	},
	
	content: String
}
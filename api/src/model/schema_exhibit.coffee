mongoose = require 'mongoose'

module.exports = mongoose.model 'exhibit', new mongoose.Schema {
	
	_id: String,
	type: String,
	site: {  type: String, ref: "site"}
}
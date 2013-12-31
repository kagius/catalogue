mongoose = require 'mongoose'

module.exports = mongoose.model 'site', new mongoose.Schema {
	
	_id: String,
	locality: {  type: String, ref: 'locality' }
	exhibits: [{  type: String, ref: 'exhibit' }]
}
mongoose = require 'mongoose'

module.exports = mongoose.model 'locality', new mongoose.Schema {
	
	_id: String
	country: {  type: String, ref: 'country' }
	sites: [{  type: String, ref: 'site' }]
}
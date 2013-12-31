mongoose = require 'mongoose'

module.exports = mongoose.model 'country', new mongoose.Schema {
	
	_id: String	
	localities: [{  type: String, ref: "locality"}]
}
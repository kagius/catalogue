mongoose = require 'mongoose'

exhibit = new mongoose.Schema {
	code: String,
	type: String,
	url: String
}

site = new mongoose.Schema {
	code: String,

	url: String,

	# Level 4: Individual items
	exhibits: { type: [exhibit], select: false }
}

locality = new mongoose.Schema {
	code: String,

	url: String,

	# Level 3: location, collection or museum
	sites: [site]
}

module.exports = mongoose.model 'Hierarchy', new mongoose.Schema {
	
	# Level 1: A country
	code: String,

	url: String,

	# level 2: Town or city
	localities: [locality]
}
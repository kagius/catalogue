var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	var callback = function(err, result) {
		if (err)
			console.log(err);
		
		db.close();
	};

	if (err) 
		console.log(err);	

	db.collection("types", function(err, collection) {

		// Clear any existing data.
		collection.drop();

		// Add our test data
		collection.insert({
			code: "",
			localizations: {
				en: {
					title: "",
					description: "",
					keywords: "",
					content: ""
				}
			}
		}, callback);	
	});
});
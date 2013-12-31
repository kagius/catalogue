var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	if (err) console.log(err);	

	db.collection("localities", function(err, collection) {

		var callback = function(err, collection) {
			if (err)
				console.log(err);

			db.close();
		}

		// Clear any existing data.
		collection.drop();

		collection.insert([
			{
				_id: "mt/valletta",
				country: "mt",
				sites: ["mt/valletta/palace-armoury"]
			},
			{
				_id: "mt/birgu",
				country: "mt",
				sites: ["mt/birgu/maritime-museum", "mt/birgu/st-josephs-oratory", ]
			},
			{
				_id: "mt/mdina",
				country: "mt",
				sites: ["mt/mdina/cathedral-museum" ]
			}
		], callback);
	});
});
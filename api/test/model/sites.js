var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	if (err) console.log(err);	

	db.collection("sites", function(err, collection) {

		var callback = function(err, collection) {
			if (err)
				console.log(err);

			db.close();
		}

		// Clear any existing data.
		collection.drop();

		collection.insert([
			{
				_id: "mt/valletta/palace-armoury",
				locality: "mt/valletta",
				exhibits: []
			},
			{
				_id: "mt/birgu/maritime-museum",
				locality: "mt/birgu",
				exhibits: []
			},
			{
				_id: "mt/birgu/st-josephs-oratory",
				locality: "mt/birgu",
				exhibits: []
			},
			{
				_id: "mt/mdina/cathedral-museum",
				locality: "mt/mdina",
				country: "mt",
				exhibits: []
			}
		], callback);
	});
});
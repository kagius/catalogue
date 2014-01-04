var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	if (err) console.log(err);	

	db.collection("exhibits", function(err, collection) {

		var callback = function(err, collection) {
			if (err)
				console.log(err);

			db.close();
		}

		// Clear any existing data.
		collection.drop();

		collection.insert([
			{
				_id: "mt/valletta/palace-armoury/longsword",
				site: "mt/valletta/palace-armoury",
				type: "longsword"
			}
		], callback);
	});
});
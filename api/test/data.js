var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	if (err) console.log(err);	

	db.collection("hierarchies", function(err, collection) {

		// Clear any existing data.
		collection.drop();

		// Add our test data
		collection.insert({
			code: "mt",
			localities: [
				{
					code: "valletta",
					sites: [{
						code: "palace",
						exhibits: [
							{
								code: "rapier",
								type: "rapier"
							},
							{
								code: "longsword",
								type: "longsword"
							},
							{
								code: "sidesword",
								type: "sidesword"
							},
							{
								code: "dagger",
								type: "dagger"
							}
						]
					}]
				},
				{
					code: "mdina",
					sites: [{
						code: "cathedral",
						exhibits: [
							{
								code: "sabre",
								type: "sabre"
							},
							{
								code: "bayonet",
								type: "bayonet"
							}
						]
					}]
				},
				{
					code: "birgu",
					sites: [
						{
							code: "maritime-museum",
							exhibits: [
								{
									code: "briquet",
									type: "hanger"
								}
							]
						},
						{
							code: "st-joseph-oratory",
							exhibits: [
								{ 
									code: "de-valette",
									type: "sidesword"
								}
							]
						}
					]
				}
			]
		}, 

		function(err, result) {
			
			if (err)
				console.log(err);

			db.close();
		});	
	});
});
var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	if (err) console.log(err);	

	db.collection("hierarchies", function(err, collection) {

		// Clear any existing data.
		collection.drop();

		// Add our test data
		collection.insert({
			code: "mt",
			url: "mt",
			localities: [
				{
					code: "valletta",
					url: "mt/valletta",
					sites: [{
						code: "palace",
						url: "mt/valletta/palace",
						exhibits: [
							{
								code: "rapier",
								url: "mt/valletta/palace/rapier",
								type: "rapier"
							},
							{
								code: "longsword",
								url: "mt/valletta/palace/longsword",
								type: "longsword"
							},
							{
								code: "sidesword",
								url: "mt/valletta/palace/sidesword",
								type: "sidesword"
							},
							{
								code: "dagger",
								url: "mt/valletta/palace/dagger",
								type: "dagger"
							}
						]
					}]
				},
				{
					code: "mdina",
					url: "mt/mdina",
					sites: [{
						code: "cathedral",
						url: "mt/mdina/cathedral",
						exhibits: [
							{
								code: "sabre",
								url: "mt/mdina/cathedral/sabre",
								type: "sabre"
							},
							{
								code: "bayonet",
								url: "mt/mdina/cathedral/bayonet",
								type: "bayonet"
							}
						]
					}]
				},
				{
					code: "birgu",
					url: "mt/birgu",
					sites: [
						{
							code: "maritime-museum",
							url: "mt/birgu/maritime-museum",
							exhibits: [
								{
									code: "briquet",
									url: "mt/birgu/maritime-museum/briquet",
									type: "hanger"
								}
							]
						},
						{
							code: "st-joseph-oratory",
							url: "mt/birgu/st-joseph-oratory",
							exhibits: [
								{ 
									url: "mt/birgu/st-joseph-oratory/de-valette",
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
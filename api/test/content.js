var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost/testcat", function(err, db) {

	var callback = function(err, result) {
		if (err)
			console.log(err);	

		db.close();	
	};

	if (err) 
		console.log(err);	

	db.collection("contents", function(err, collection) {

		// Clear any existing data.
		collection.drop();

		// Add our test data
		collection.insert([{
			url : "",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Home",
				description: "Country selection",
				keywords: "Bla bla bla",	
			},

			content: "pick a country"
		},

		{
			url : "mt",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Malta",
				description: "Collections in Malta",
				keywords: "Bla bla bla",	
			},

			content: "Some text about malta"
		},

		{
			url : "mt/valletta",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Valletta",
				description: "Collections in Valletta",
				keywords: "Bla bla bla",	
			},

			content: "Some text about valletta"
		},

		{
			url : "mt/birgu",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Birgu",
				description: "Collections in birgu",
				keywords: "Bla bla bla",	
			},

			content: "Some text about birgu"
		},

		{
			url : "mt/mdina",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Mdina",
				description: "Collections in mdina",
				keywords: "Bla bla bla",	
			},

			content: "Some text about mdina"
		},

		{
			url : "mt/valletta/palace-armoury",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "The Palace Armoury",
				description: "Collections in the Palace Armoury, Valletta",
				keywords: "Bla bla bla",	
			},

			content: "Some text about the Armoury"
		}], callback);	


	});
});
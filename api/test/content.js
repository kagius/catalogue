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
		},
		
		{
			url : "mt/valletta/palace-armoury/longsword",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Longsword",
				description: "Longsword in the palace armoury collection",
				keywords: "Bla bla bla",	
			},

			content: "some text about the longsword"
		},

		{
			url : "404",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "This is not the page you are looking for",
				description: "Whatever it was you were looking for isn't here",
				keywords: "not found",	
			},

			content: "Not found!"
		},

		{
			url : "page/about",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "About",
				description: "Some information about this site",
				keywords: "about",	
			},

			content: "Some information about this site."
		},

		{
			url : "page/contact",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "Contact",
				description: "contact us",
				keywords: "contact form",	
			},

			content: "You can use this form to contact us."
		},

		{
			url : "types/longsword",

			language: {
				country: "GB",
				locale: "en-GB",
				language : "en"
			},

			meta: {
				title: "About longswords",
				description: "Some information about longswords",
				keywords: "longsword, bastard sword, two handed sword",	
			},

			content: "Information about the longsword"
		}
		], callback);	


	});
});
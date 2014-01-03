/*
 * Sample application configuration file.
 * To set up the configuration, rename this file to config.js and change the settings as needed.
 */ 
module.exports = {

	// HTTP Listener port
	port: 8080,

	globals: {
		baseUrl: "http://localhost:8080"
	},

	// Static file service directory.
	// To be moved into ngnix eventually
	assets: {
		baseUrlPattern: /\/assets\/?.*/,
		basePath: "./assets",
	},

	headers: {
		// Ajax cross-domain whitelists
		accessControlAllowOrigins: "http://127.0.0.1:8000"
	},

 	templates: {
 		path: __dirname + '/../templates/'
 	},

	// Logging levels
	logging: {
		trace: true,
		debug: true,
		info: true
	},

	// Database connection details
	db:{
		url: "mongodb://localhost/testcat"
	}
};

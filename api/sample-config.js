/*
 * Sample application configuration file.
 * To set up the configuration, rename this file to config.js and change the settings as needed.
 */ 
module.exports = {

	// HTTP Listener port
	port: 8080,

	globals: {
		baseUrl: "http://www.tbd.org"
	},

	defaultLanguage: "en",

	// Static file service directory.
	// If servestatic is true, the server will take care of static file requests. 
	// Otherwise, they will be handled by the web server.
	assets: {
		serveStatic: false,
		baseUrlPattern: /\/assets\/?.*/,
		basePath: "./assets",
	},

	headers: {
		// Ajax cross-domain whitelists
		//accessControlAllowOrigins: "http://127.0.0.1:8000"
	},

	mail: {
		transport: {
			type: "SMTP",
			options: {
				host: "smtp.gmail.com",
				secureConnection: true,
				port: 465,
				auth: {
					user: "gmail.user@gmail.com",
					pass: "userpass"
				}
			}
		},
		sender: "gmail.user@gmail.com",
		recipient: "gmail.user@gmail.com"
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

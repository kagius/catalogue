var Server = require("../dist/server.js");

exports.shouldRegisterHandlers = function(test){

	var app = {
		config: {
			port:9000,
			logging : {
				trace : false
			}
		},
		server : null
	};

	app.server = new Server(app);

	var handlers = [ 
		{
			name: "test1",
			method: "get",
			routes: ["test1/:param"],
			version: "0.0.0",
			implementation: function(req, callback) {
				return true;
			},
			htmlTemplate: "something"
		},
		{
			name: "test2",
			method: "get",
			routes: ["test2/:param"],
			version: "0.0.0",
			implementation: function(req, callback) {
				return true;
			},
			htmlTemplate: "something-else"
		},
	];

	app.server.registerHandlers("/", handlers);
	test.equal(app.server.server.router.routes.GET.length, 2, "A route should be added for each handler.");
	test.done();
}
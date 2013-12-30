require(['jquery', 'jquery.history'], function ($) {
'use strict';

	var content = $("#content");
	var loader = $("#loader");

	var local = {};

	History.Adapter.bind(window,'statechange',function(){ 
        var state = History.getState();
        var hash = state.hash;
        
        // Show the loader.
        content.html(loader.html());

        // Check if we have the data in storage.
        if (local[hash]) {
        	
        	// update the container.
        	content.html(local[hash]);
        } else {

        	$.get("/api/html" + hash)
        	 .done(function(data) {
        	 	local[hash] = data;
        	 	content.html(local[hash]);
        	 })
        }
    });


	// Override the default click handler for internal links.
	$(document.body).on('click', 'a:not([href^=http])' , function(){		

		var link = $(this);
		var url = link.attr("href");

		History.pushState(null, null, url);
		return false;
	});
});
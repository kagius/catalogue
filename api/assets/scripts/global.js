requirejs.config({
    paths: {
        ga: '//www.google-analytics.com/analytics'
    }
});

require(['jquery', 'jquery.history', 'ga'], function ($) {
'use strict';

	var content = $("#content");
	var loader = $("#loader");

	var local = {};

    // Set up google analytics
    window.ga('create', 'UA-46857586-1');
    window.ga('send', 'pageview');

    var updateContent = function(data) {

        // Update page metadata
        document.title = data.meta.title;
        $("meta[property='og:title']").attr("content", data.meta.title);

        $("meta[name='description'], meta[property='og:description']").attr("content", data.meta.description);
        $("meta[name='keywords']").attr("content", data.meta.keywords);

        $("link[rel='canonical']").attr("href", data.url);
        $("meta[property='og:url']").attr("content", data.url);

        // Update page content
        content.html(data.content);
    }

    var load = function(hash, callback) {

        // If we downloaded this already, fetch from our local stash
        if (local[hash]) {
            callback(local[hash]);
            return;
        }

        // Otherwise, fetch it now.
        // Show the loader.
        content.html(loader.html());

        var jsonUrl = (hash == "/") ? "" : hash;

        $.get("/api" + jsonUrl).done(function(data) {
            local[hash] = data;                
            callback(local[hash]);
        })
    }

    // Bind the history adapter so the required content is loaded
    // when a new hash is pushed to history.
	History.Adapter.bind(window,'statechange',function(){ 
        var state = History.getState();
        var hash = state.hash;    

        load(hash, updateContent);
    });


	// Override the default click handler for internal links.
    // If javascript is not available for some reason, all inks should
    // just behave like normal links.
	$(document.body).on('click', 'a:not([href^=http])' , function(){		

        var target = $(this).attr("href");

        // Grab the href from the anchor and push it to history.
		History.pushState(null, null, target);

        // Notify Google analytics.
        window.ga("send", "event", "link", "click", "content", target);

        // Return false to prevent the normal link behaviour from firing.
        // (We don't want the browser to reload the page)
        return false;
	});
});
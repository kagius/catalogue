requirejs.config({
    paths: {
        ga: '//www.google-analytics.com/analytics'
    }
});

require(['jquery', 'jquery.history', 'ga', 'collapse', 'dropdown'], function ($) {
'use strict';

    var content = $("#content");
    var loader = $("#loader");
    var lang = $("html").attr("lang");

    var local = {};

    // Set up google analytics
    window.ga('create', 'UA-46857586-1', { 'cookieDomain': 'none' });
    window.ga('send', 'pageview');

    var updateContent = function(hash, data) {

        // Update page metadata
        document.title = data.meta.title;
        $("meta[property='og:title']").attr("content", data.meta.title);

        $("meta[name='description'], meta[property='og:description']").attr("content", data.meta.description);
        $("meta[name='keywords']").attr("content", data.meta.keywords);

        $("link[rel='canonical']").attr("href", data.url);
        $("meta[property='og:url']").attr("content", data.url);
        $(".languages a").each(function() {
           var link = $(this);
           link.attr("href", link.data("base") + data.path);
        });

        // Update page content
        content.html(data.content);

        if (hash)
            window.ga('send', 'pageview', { page: hash, title: data.meta.title });
    }

    var load = function(hash, callback) {

        // If we downloaded this already, fetch from our local stash
        if (local[hash]) {
            callback(hash, local[hash]);
            return;
        }

        // Otherwise, fetch it now.
        // Show the loader.
        content.html(loader.html());

        var jsonUrl = (hash == "/") ? "" : hash;

        $.get("/api" + jsonUrl).done(function(data) {
            local[hash] = data;                
            callback(hash, local[hash]);
        })
    }

    // Bind the history adapter so the required content is loaded
    // when a new hash is pushed to history.
    History.Adapter.bind(window,'statechange',function(){ 
        var state = History.getState();
        var hash = state.hash;    

        load(hash, updateContent);
    });


    // Override the default click handler for internal links. (Internal as in, 
    // on the same site, not the same page.)
    // If javascript is not available for some reason, all links should
    // just behave like normal links.
    $(document.body).on('click', 'a:not([href^=http]):not([href=#])' , function(){      

        var target = $(this).attr("href");

        // Grab the href from the anchor and push it to history.
        History.pushState(null, null, target);

        // Return false to prevent the normal link behaviour from firing.
        // (We don't want the browser to reload the page)
        return false;
    });

    // Override the default submit handler for the mailer.
    // If javascript is not available for some reason, it will behave like a normal submit button.
    $(document.body).on('click', '#contactEmail input[type=submit]' , function(){      

       

        var jsonUrl = $("#contactEmail").attr("action")

        $.post("/api" + jsonUrl, {
            "subject": $("#subject").val(),
            "address": $("#address").val(),
            "message": $("#message").val()
        }).done(function(data) {       

            // To do: Register analytics event
            updateContent(null, data);
        })

        content.html(loader.html());
        
        // Return false to prevent the normal behaviour from firing.
        // (We don't want the browser to reload the page)
        return false;
    });
});
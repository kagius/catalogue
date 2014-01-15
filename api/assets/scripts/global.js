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

        // remove alt urls
        $("link[rel=alternate]").remove();

        // Update language menu and alt urls.
        $("a.language").each(function() {
           var link = $(this);
           var lang = link.data("lang");
           var localizedUrl = link.data("base") + data.path;

           link.attr("href", localizedUrl);
           $("head").append("<link rel=\"alternate\" hreflang=\"" + lang + "\" href=\"" + localizedUrl + "\" />");
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

        var address = $("#address").val();
        var message = $("#message").val();

        var addressMissing = (!address || address.length < 1);
        var addressFormatWrong = (!addressMissing && (!/\S+@\S+\.\S+/.test(address)))
        var hasEmailIssue = addressMissing || addressFormatWrong;

        var messageMissing = (!message || message.length < 1);
        var messageTooShort = (!messageMissing && message.length < 50);
        var messageTooLong = (!messageMissing && message.length > 1000);
        var hasMessageIssue = messageMissing || messageTooShort || messageTooLong;

        if (hasEmailIssue) {
            $("#emailError").show();
            if (addressMissing) $("#emailMissing").show(); else $("#emailMissing").hide();
            if (addressFormatWrong) $("#emailFormatWrong").show(); else $("#emailFormatWrong").hide();
        } else {
            $("#emailError").hide();
        }

        if (hasMessageIssue) {
            $("#messageError").show();
            if (messageMissing) $("#messageMissing").show(); else $("#messageMissing").hide();
            if (messageTooShort) $("#messageTooShort").show(); else $("#messageTooShort").hide();
            if (messageTooLong) $("#messageTooLong").show(); else $("#messageTooLong").hide();
        } else {
            $("#messageError").hide();
        }

        if (hasEmailIssue || hasMessageIssue)
            return false;

        $.post("/api" + jsonUrl, {
            "address": address,
            "message": message
        }).done(function(data) {       

            // Register analytics event
            window.ga('send', 'event', 'email', 'sent');

            updateContent(null, data);
        })

        content.html(loader.html());
        
        // Return false to prevent the normal behaviour from firing.
        // (We don't want the browser to reload the page)
        return false;
    });

    // Close the menu dropdown when contact or about are clicked (since they will not result in a page load, 
    // the mobile menu would otherwise stay open).
    $(document.body).on('click', '.menuitem', function(){
        $(".navbar-header .navbar-toggle").click();
    });
});
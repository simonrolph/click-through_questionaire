# A click-through questionaire

R shiny app to act as an interim page to ask users something before they go to their destination page to capture immediate feedback.

**Motivation:**

You are doing a study to see why people click on certain links and you want to get immediate feedback on why they clicked that link. This small shiny app is a template for setting up an interim page between the user clicking on the link and the user getting to their destination. 

**Implementation:**

This is currently set up for a specific case whereby users are always going to the same website, but different 'deep-link' urls with a standard query format (https://en.wikipedia.org/wiki/Query_string).

This has been developed as part of the DECIDE project (https://www.ceh.ac.uk/our-science/projects/decide) whereby we are sending personalised data-generated emails with different deep links for the DECIDE tool (https://decide.ceh.ac.uk/opts/scoremap).

For example, a link in an email may take to them to a perticular location eg. https://decide.ceh.ac.uk/opts/scoremap?lat=53&lon=-1.5&zoom=12

We want to get some feedback in they followed that link. So instead of directly sending them to that link we deploy this R Shiny app and send them to wherever you hve deployed your shiny app with the same query paremeters. So for example if I'm testing locally I go to this address http://127.0.0.1:5229/?lat=53&lon=-1.5&zoom=12

It get's the query parameters like so

```
query <- parseQueryString(session$clientData$url_search)
```

This will take the query parameters in this link and create a button which takes you to the onwards link. It edits the `href` of the button to be the link by doing (where `fwd_address` is the rebuild URL from the `query` parameters):

```
runjs(
    paste0(
        'document.getElementById("skipbutton").href="',
        fwd_address,
        '";'
    )
)
```

Then you can put in this shiny app any buttons, input boxes etc. you wish to get feedback via. You could save that data to a local csv or a remote google sheet. Could even iframe a questionaire from another site.

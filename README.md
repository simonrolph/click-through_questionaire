# A click-through questionaire

R shiny app to act as an interim page to ask users something before they go to their destination page to capture immediate feedback.

### Motivation:

You are doing a study to see why people click on certain links and you want to get immediate feedback on why they clicked that link. This small shiny app is a template for setting up an interim page between the user clicking on the link and the user getting to their destination. 

![image](https://user-images.githubusercontent.com/17750766/170453800-91b4da77-8b3d-49a6-b358-460cbfe45509.png)


### Implementation:

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

### Screenshot

This is what the interim page looks like:

![image](https://user-images.githubusercontent.com/17750766/170462752-6f82ae50-6597-4aa0-bd61-5f5cd7a570a7.png)

### How to use

1. Establish your research question and why using this approch is valid (as it does interupt the user experience so only use if you are certain it is essential for your research question).
2. Create a fork of this repository
3. Edit the base url
4. Add any inputs you want to get feedback from users 
5. Set up a way to store uers response data interally or externally
6. Style app with css + logo/favicon etc. (optional)
7. Ensure you are GDPR compliant with a terms of service / privacy statement etc.
8. Deploy on shinyapps.io or RStudio Connect etc.
9. Send users to the app rather than straight to the target website
10. Collect and analyse data for your research project

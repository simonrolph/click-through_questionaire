library(shiny)
library(htmltools)
library(shinyjs)  # for runjs()

# this is where you set the url of your website that the user goes to
base_url <- "https://decide.ceh.ac.uk/opts/scoremap/map"
error_if_no_params <- F

#rather clunky url builder - I'm sure there must be something like this already!
build_url <- function(url_args){
    q <- "?"
    
    for (i in 1:length(url_args)){
        q <- paste0(q,names(url_args)[i],"=")
        q <- paste0(q,unlist(url_args)[i])
        
        if(i<length(url_args)){
            q <- paste0(q,"&")
        }
    }
    q
}

# Define UI for application 
ui <- fluidPage(
    useShinyjs(),
    
    div(
        id = "inputs",
        style="padding:30px;text-align: center !important;",

        # Application title
        titlePanel("Thanks for clicking"),
        
        #put some inputs here
        checkboxGroupInput(
            "feedback",
            "Wy did you click on this link?",
            choiceNames = c("It was interesting",
                            "It was engaging",
                            "The other links were rubbish",
                            "I'm not sure"),
            choiceValues = 1:4,
            width = "100%"),
        
        #submit button
        actionButton("submit_res", "Submit response",class = "btn-primary"),
        
        #skit button
        a("Skip",
          id="skipbutton",
          class="btn btn-default",
          type="button"),
        
        br(),
        br(),
        
        a("Privacy statement",
          href="", #set the URL of your privacy statement
          target="_blank" # so it opens in a new window
          )
    
    )

)

# Define server logic
server <- function(input, output,session) {
    
    #reactive expression for the forwarding address based on the url parameters
    fwd_address <- reactive({
        query <- parseQueryString(session$clientData$url_search)
        if (is.null(names(query))) {
            fwd <- base_url
        } else {
            fwd <- paste0(base_url,build_url(query))
        }
        fwd
    })
    
    
    #set the url of the onward button 
    observe({
        query <- parseQueryString(session$clientData$url_search)
        
        #check if there are any query parameters
        if (is.null(names(query))) {
            
            #either put up a little error message if there's no deep link
            if(error_if_no_params){
                runjs(
                    paste0(
                        'document.getElementById("inputs").innerHTML="Error";'
                    )
                )
            } else {
                #or just take the user to the page with no params
                runjs(
                    paste0(
                        'document.getElementById("skipbutton").href="',
                        fwd_address(),
                        '";'
                    )
                )
            }
            
        } else  {
            #update the url of the skip button to the deep link
            runjs(
                paste0(
                    'document.getElementById("skipbutton").href="',
                    fwd_address(),
                    '";'
                )
            )
        }
        
    })

    #clicking on the submit button saves data then goes to onward link
    observeEvent(input$submit_res, {
        #submit their responses to a database (or csv/log etc.)
        
        #get the information from the app
        query <- parseQueryString(session$clientData$url_search)
        res <- input$feedback
        
        #save it somewhere
        #write.table / log etc.
        
        #take user to the onwards page
        runjs(
            paste0(
                'window.location.href ="',
                fwd_address(),
                '";'
            )
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

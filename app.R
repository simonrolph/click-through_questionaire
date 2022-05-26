#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(htmltools)
library(shinyjs)


base_url <- "https://decide.ceh.ac.uk/opts/scoremap/map"

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
        style="text-align:center;padding:100px;",

        # Application title
        titlePanel("Hello"),
        
        p("Here is where you could put some inputs"),
        
        a("Skip",
          id="skipbutton",
          class="btn btn-primary",
          type="button")
    
    )

)

# Define server logic
server <- function(input, output,session) {
    observe({
        query <- parseQueryString(session$clientData$url_search)
        
        if (is.null(print(names(query)))) {
            #error
            runjs(
                paste0(
                    'document.getElementById("inputs").innerHTML="Error";'
                )
            )
            
        } else  {
            fwd_address <- paste0(base_url,build_url(query))
            
            #update the url of the skip button
            runjs(
                paste0(
                    'document.getElementById("skipbutton").href="',
                    fwd_address,
                    '";'
                )
            )
            print(fwd_address)
        }
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

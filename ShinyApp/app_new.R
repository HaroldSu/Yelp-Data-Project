library(shiny)
library(dplyr)

data <- read.csv("./data/score.csv")
source("./ShinyApp/global.R")

# Define UI ====
ui <- fluidPage(
  navbarPage(
    title = "Yelp Data Project",
    id = "main_navbar",
    
    # Tab 1: Attributes ----------
    tabPanel(
      title = "Attribute",
      
    ), # End of Tab 1
    
    # Tab 2: Feedback for each business ----------
    tabPanel(
      title = "Feedback",
      sidebarLayout(
        # Sidebar panel for inputs ----------
        sidebarPanel(
          # Input: character entry for business name or business ID -----
          textInput(inputId = "Business_input",
                    label = "Input your business name or ID:",
                    value = "Po' Boys Restaurant"),
          # Input: Selector for choosing type to analyze -----
          selectInput(inputId = "Type_input",
                      label = "Choose a type:",
                      choices = c("service", "price", "environment", "food quality", "menu")),
          uiOutput(outputId = "key_word"),
          
        ), # End of sidebarPanel
        
        # Main panel for displaying outputs
        mainPanel(
          # Output: text content
          htmlOutput("text"),
          # Output: histogram
          plotOutput("Hist"),
          
        ) # End of mainPanel
      ) # End of sidebarLayout
    ) # End of Tab 2
    
  ) # End of navbarPage
  
) # End of ui


server <- function(input, output){
  key_words_by_type <- reactive({
    data %>% 
      filter(type == input$Type_input) %>% 
      select(key_word)
  })
  output$key_word <- renderUI({
    selectInput("Key_input", "Choose a key word or 'SUMMARY' for the summary of the current type:",
                choices = c("SUMMARY", key_words_by_type()$key_word))
  })
  h3(output$text <- renderUI({
    HTML(display_text(Business = input$Business_input, Type = input$Type_input, Key = input$Key_input))
  }))
  output$Hist <- renderPlot({
    display_hist(Business = input$Business_input, Type = input$Type_input, Key = input$Key_input)
  })
  
}
shinyApp(ui, server)

library(shiny)
library(stats)
library(dplyr)
library(shinythemes)
library(ggplot2)


data <- read.csv("data/score.csv")
attr <- read.csv("data/attr_test_result.csv")
# Function to output text
display_text <- function(Business,Type, Key){
  # Index of obs whose name or id matching input
  index_business_match_id <- which(data$business_id == Business)
  index_business_match_name <- which(data$name == Business)
  index_business_match <- unique(c(index_business_match_id,index_business_match_name))
  
  # Data of the business matching input business name or id
  data_business_match <- data[index_business_match, ]
  
  if(Type != "menu"){
    # Data grouped by type
    data_grouped_by_type <- data %>% 
      group_by(business_id, type) %>% 
      summarize(counts_of_type = sum(counts), score_of_type = mean(score),.groups = 'drop')
    
    if(length(index_business_match) == 0){
      print(paste('There is neither business id nor business name matching \"', Business, '\".<br/>', sep = ""))
    }else if(length(which(data_business_match$type == Type)) == 0){
      print(paste('There is no review mentioning your \"', Type, '\".<br/>', sep = ""))
    }else{
      if(Key == "SUMMARY" | is.na(Key)){
        # Score of the matching business with a given type 
        score <- mean(data_business_match$score[data_business_match$type == Type])
        
        # Count of reviews mentioning the given type for the matching business  
        count_of_reviews <- sum(data_business_match$counts[data_business_match$type == Type])
        
        # Percentage of businesses whose score in the given type are lower than the matching business
        percent_better_than <- round(sum(data_grouped_by_type$score_of_type[data_grouped_by_type$type == Type] < score) 
                                     / dim(data_grouped_by_type[(data_grouped_by_type$type == Type),])[1] 
                                     * 100, digits = 1)
        
        print(paste('Your', Type, 'score is', round(score,digits = 2), 'given by totally', count_of_reviews,
                    'reviews mentioning this aspect. It is better than', percent_better_than, 'percent of all',
                    dim(data_grouped_by_type[(data_grouped_by_type$type == Type),])[1], 'businesses, while the median score is',
                    round(median(data_grouped_by_type$score_of_type[data_grouped_by_type$type == Type]), digits = 2),
                    '.<br/>'))
      }else{
        if(length(which(data_business_match$key_word == Key)) != 0){
          score <- data_business_match$score[data_business_match$key_word == Key]
          count_of_reviews <- data_business_match$counts[data_business_match$key_word == Key]
          percent_better_than <- round(sum(data$score[data$key_word == Key] < score) 
                                       / length(data$score[data$key_word == Key]) 
                                       * 100, digits = 1)
          print(paste('Your', Key, 'score is', round(score,digits = 2), 'given by totally', count_of_reviews,
                      'reviews with this key word. It is better than', percent_better_than, 'percent of all',
                      length(data$score[data$key_word == Key]), 'businesses, while the median score is',
                      round(median(data$score[data$key_word == Key]), digits = 2),
                      '.<br/>'))  
        }else{
          print(paste('There is no review mentioning your \"', Key, '\".<br/>', sep = ""))
        }
      }
    }
  }else{
    if(length(which(data_business_match$type == "menu")) == 0){
      paste("There is no review mentioning any specific food in your menu.")
    }else{
      if(Key == "SUMMARY" | is.na(Key)){
        food_list <- data_business_match$key_word[data_business_match$type == "menu"]
        food_list_impressive <- c()
        i <- 1
        food_list_to_improve <- c()
        j <- 1
        for(food in food_list){
          score <- data_business_match$score[data_business_match$key_word == food]
          score_of_food <- data$score[data$key_word == food]
          percent_better_than <- round(sum(score_of_food <= score) / length(score_of_food) * 100, digits = 2)
          if(percent_better_than >= 80){
            food_list_impressive[i] <- food
            i <- i + 1
          } 
          if(percent_better_than <=20){
            food_list_to_improve[j] <- food
            j <- j + 1
          } 
        }
        
        if(length(food_list_impressive) != 0){
          output_1 <- 'According to reviews, the following food related elements in your menu are considered to be impressive: <br/>'
          for(content in food_list_impressive) output_1 <- paste(output_1, content, sep = " ")
        }else output_1 <- 'None of food related elements in your menu is considered to be impressive by reviews. '
        
        if(length(food_list_to_improve) != 0){
          output_2 <- 'Reviews suggest that the following food related elements in your menu may need to improve: <br/>'
          for(content in food_list_to_improve) output_2 <- paste(output_2, content, sep = " ")
        }else output_2 <- 'Reviews indicate that none of food related elements in your menu mentioned by reviews have to improve.'
        
        print(paste(output_1, output_2, sep = "<br/><br/>"))
      }else{
        if(length(which(data_business_match$key_word == Key)) != 0){
          score <- data_business_match$score[data_business_match$key_word == Key]
          count_of_reviews <- data_business_match$counts[data_business_match$key_word == Key]
          percent_better_than <- round(sum(data$score[data$key_word == Key] < score) 
                                       / length(data$score[data$key_word == Key]) 
                                       * 100, digits = 1)
          print(paste('Your', Key, 'score is', round(score,digits = 2), 'given by totally', count_of_reviews,
                      'reviews with this key word. It is better than', percent_better_than, 'percent of all',
                      length(data$score[data$key_word == Key]), 'businesses, while the median score is',
                      round(median(data$score[data$key_word == Key]), digits = 2),
                      '.<br/>'))
        }else{
          print(paste('There is no review mentioning your \"', Key, '\".<br/>', sep = ""))
        }
      }
    }
  }
}

# Function to output histogram
display_hist <- function(Business,Type,Key){
  # Index of obs whose name or id matching input
  index_business_match_id <- which(data$business_id == Business)
  index_business_match_name <- which(data$name == Business)
  index_business_match <- unique(c(index_business_match_id,index_business_match_name))
  
  # Data of the business matching input business name or id
  data_business_match <- data[index_business_match, ]
  if(Type != "menu"){
    if(Key == "SUMMARY"){
      # Data grouped by type
      data_grouped_by_type <- data %>% 
        group_by(business_id, type) %>% 
        summarize(counts_of_type = sum(counts), score_of_type = mean(score),.groups = 'drop')
      
      if(length(index_business_match) != 0 & length(which(data_business_match$type == Type)) != 0){
        # Score of the matching business with a given type 
        score <- mean(data_business_match$score[data_business_match$type == Type])
        
        # Percentage of businesses whose score in the given type are lower than the matching business
        percent_better_than <- round(sum(data_grouped_by_type$score_of_type[data_grouped_by_type$type == Type] < score) 
                                     / dim(data_grouped_by_type[(data_grouped_by_type$type == Type),])[1] 
                                     * 100, digits = 1)
        
        # Histogram
        # p <- hist(data_grouped_by_type$score_of_type[data_grouped_by_type$type == Type], freq = F,
        #           main = Type,
        #           cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
        # abline(v = score, col = "red", lwd = 2)
        # text_position_x_1 <- (min(p$breaks) + score) / 2
        # text_position_x_2 <- (max(p$breaks) + score) / 2
        # text_position_y <- max(p$density) * 0.8
        # text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
        #      col = "red", cex = 1.2)
        # text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|"),
        #      col = "red", cex = 1.2)
        index_type = which(data_grouped_by_type$type == Type)
        p <- ggplot(data = data_grouped_by_type[index_type,]) +
          geom_histogram(aes(x = data_grouped_by_type$score_of_type[index_type], y = ..density..),
                         binwidth = 0.5,
                         col="azure4", 
                         fill="deepskyblue3", 
                         alpha = 0.7) + 
          labs(title=Type, x="Score", y="Density")
        text_position_x_1 <- (min(data_grouped_by_type$score_of_type) + 2*score) / 3
        text_position_x_2 <- (max(data_grouped_by_type$score_of_type) + 2*score) / 3
        text_position_y <- 0.4
        p + geom_vline(xintercept = score, linetype = "dashed", color = "coral1", lwd = 1.5) +
          geom_text(fontface="italic", x = text_position_x_1, y = text_position_y, label = as.character(paste0("|<  ", percent_better_than, "%  >|")),size = 10,color ="deepskyblue4") +
          geom_text(fontface="italic", x = text_position_x_2, y = text_position_y, label = as.character(paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|")),size = 10,color ="deepskyblue4") +
          theme(plot.title=element_text(colour = "black", size = 25, hjust = 0.5),
                axis.title.x=element_text(size = 20),
                axis.title.y=element_text(size = 20),
                axis.text.x=element_text(size = 15),
                axis.text.y=element_text(size = 15),
                panel.background = element_rect(fill = "lightcyan2"))
      }
    }else{
      if(length(which(data_business_match$key_word == Key)) != 0){
        score <- data_business_match$score[data_business_match$key_word == Key]
        percent_better_than <- round(sum(data$score[data$key_word == Key] < score) 
                                     / length(data$score[data$key_word == Key]) 
                                     * 100, digits = 1)
        
        # Histogram
        # p <- hist(data$score[data$key_word == Key], freq = F,
        #           main = Key,
        #           cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
        # abline(v = score, col = "red", lwd = 2)
        # text_position_x_1 <- (min(p$breaks) + score) / 2
        # text_position_x_2 <- (max(p$breaks) + score) / 2
        # text_position_y <- max(p$density) * 0.8
        # text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
        #      col = "red", cex = 1.2)
        # text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|"),
        #      col = "red", cex = 1.2)
        index_type = which(data$key_word == Key)
        p <- ggplot(data = data[index_type,]) +
          geom_histogram(aes(x = data$score[index_type], y = ..density..),
                         binwidth = 0.5,
                         col="azure4",
                         fill="deepskyblue3",
                         alpha = 0.7) +
          labs(title=Type, x="Score", y="Density")
        text_position_x_1 <- (min(data$score) + 2*score) / 3
        text_position_x_2 <- (max(data$score) + 2*score) / 3
        text_position_y <- 0.4
        p + geom_vline(xintercept = score, linetype = "dashed", color = "coral1", lwd = 1.5) +
          geom_text(fontface="italic", x = text_position_x_1, y = text_position_y, label = as.character(paste0("|<  ", percent_better_than, "%  >|")),size = 10,color ="deepskyblue4") +
          geom_text(fontface="italic", x = text_position_x_2, y = text_position_y, label = as.character(paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|")),size = 10,color ="deepskyblue4") +
          theme(plot.title=element_text(colour = "black", size = 25, hjust = 0.5),
                axis.title.x=element_text(size = 20),
                axis.title.y=element_text(size = 20),
                axis.text.x=element_text(size = 15),
                axis.text.y=element_text(size = 15),
                panel.background = element_rect(fill = "lightcyan2"))
      }
    } 
  }else{
    if(Key != "SUMMARY" & length(which(data_business_match$key_word == Key)) != 0){
      score <- data_business_match$score[data_business_match$key_word == Key]
      percent_better_than <- round(sum(data$score[data$key_word == Key] < score) 
                                   / length(data$score[data$key_word == Key]) 
                                   * 100, digits = 1)
      
      # Histogram
      # p <- hist(data$score[data$key_word == Key], freq = F,
      #           main = Key,
      #           cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
      # abline(v = score, col = "red", lwd = 2)
      # text_position_x_1 <- (min(p$breaks) + score) / 2
      # text_position_x_2 <- (max(p$breaks) + score) / 2
      # text_position_y <- max(p$density) * 0.8
      # text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
      #      col = "red", cex = 1.2)
      # text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|"),
      #      col = "red", cex = 1.2)
      index_type = which(data$key_word == Key)
      p <- ggplot(data = data[index_type,]) +
        geom_histogram(aes(x = data$score[index_type], y = ..density..),
                       binwidth = 0.5,
                       col="azure4", 
                       fill="deepskyblue3", 
                       alpha = 0.7) + 
        labs(title=Type, x="Score", y="Density")
      text_position_x_1 <- (min(data$score) + 2*score) / 3
      text_position_x_2 <- (max(data$score) + 2*score) / 3
      text_position_y <- 0.4
      p + geom_vline(xintercept = score, linetype = "dashed", color = "coral1", lwd = 1.5) +
        geom_text(fontface="italic", x = text_position_x_1, y = text_position_y, label = as.character(paste0("|<  ", percent_better_than, "%  >|")),size = 10,color ="deepskyblue4") +
        geom_text(fontface="italic", x = text_position_x_2, y = text_position_y, label = as.character(paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|")),size = 10,color ="deepskyblue4") +
        theme(plot.title=element_text(colour = "black", size = 25, hjust = 0.5),
              axis.title.x=element_text(size = 20),
              axis.title.y=element_text(size = 20),
              axis.text.x=element_text(size = 15),
              axis.text.y=element_text(size = 15),
              panel.background = element_rect(fill = "lightcyan2"))
    }
  }
}

# Define UI ====
ui <- fluidPage(
  theme = shinytheme("readable"),
  navbarPage(
    title = "Yelp Data Project",
    id = "main_navbar",
    
    # Tab 1: Feedback for each business ----------
    tabPanel(
      title = "Feedback to Your Business",
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
                      choices = c("service", "price", "environment", "food quality", "menu"),
                      selected = "serbive"),
          uiOutput(outputId = "key_word")
          
        ), # End of sidebarPanel
        
        # Main panel for displaying outputs
        mainPanel(
          # Output: text content
          htmlOutput("text"),
          # Output: histogram
          plotOutput("Hist")
          
        ) # End of mainPanel
      ) # End of sidebarLayout
    ), # End of Tab 1
    
    # Tab 2: Attributes ----------
    tabPanel(
      title = "Tips for Attributes",
      sidebarLayout(
        # Sidebar panel for inputs ----------
        sidebarPanel(
          # Input: Selector for choosing an attribute to see the test result -----
          radioButtons(inputId = "Attributes_input",
                    label = "Choose an attribute",
                    choices = c("RestaurantsAttire","RestaurantsTakeOut","BusinessAcceptsCreditCards", "NoiseLevel",                
                                "GoodForKids","RestaurantsReservations", "RestaurantsGoodForGroups","BikeParking",           
                                "RestaurantsPriceRange2","HasTV","Alcohol","RestaurantsDelivery","ByAppointmentOnly",         
                                "OutdoorSeating","Caters","WheelchairAccessible","WiFi","BYOB","Corkage",                   
                                "RestaurantsTableService","BusinessAcceptsBitcoin","HappyHour","DogsAllowed","CoatCheck",
                                "BYOBCorkage","DriveThru","GoodForDancing","Smoking"),
                    selected = "RestaurantsAttire"),
          ),# End of sidebarPanel
        # Main panel for displaying outputs
        mainPanel(
          # Output: Attribute
          h4(textOutput("attr_name")),
          # Output: test result
          h5(textOutput("attr_text")),
          uiOutput("wiki")
          
        ) # End of mainPanel
      ) # End of sidebarLayout
    ), # End of Tab 2
    
    # Tab 3: Contact us ----------
    tabPanel(
      title = "Contact Us",
      mainPanel(
        h4(textOutput("group")),
        h6(textOutput("email1")),
        h6(textOutput("email2")),
        h6(textOutput("email3")),
        h4(textOutput("contact")),
        uiOutput("git")
      )
    ) # End of Tab 3
    
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
                choices = c("SUMMARY", key_words_by_type()$key_word), 
                selected = "SUMMARY")
  })
  h3(output$text <- renderUI({
    HTML(ifelse(!is.null(input$Key_input), display_text(Business = input$Business_input, Type = input$Type_input, Key = input$Key_input), "Please wait."))
  }))
  output$Hist <- renderPlot({
    if(!is.null(input$Key_input)) display_hist(Business = input$Business_input, Type = input$Type_input, Key = input$Key_input)
  })
  
  output$attr_name =renderText(input$Attributes_input)
  output$attr_text = renderText({
    if(attr$p.value[attr$Attribute == input$Attributes_input] < 0.05) {
      Res1 = paste0("According to our statistical test, this attribute has significant influence to your pizza business, you may enhance it to improve the stars customers rated for your restaurant!")
    } else {
      Res1 = paste0("According to our statistical test, this attribute seems not influencial to the stars customers rated for your pizza business. You may manage it as you wish.")
    }
    return(Res1)
  })
  
  wikilink <- a("Kruskal–Wallis H test", href="https://en.wikipedia.org/wiki/Kruskal–Wallis_one-way_analysis_of_variance")
  output$wiki <- renderUI({
    tagList("If you are interested in the statistical principles behind the test, see:", wikilink)
  })
  
  output$group = renderText("Designed by:")
  output$email1 =renderText("Augustine Tong: rtang56@wisc.edu")
  output$email2 =renderText("Harold Su: hsu69@wisc.edu")
  output$email3 =renderText("Zijin Wang: zwang2548@wisc.edu")
  
  output$contact = renderText("Feel free to contact us via email if you come across any problems while using:D")
  
  gitlink <- a("Yelp Data Project", href="https://github.com/HaroldSu/Yelp-Data-Project")
  output$git <- renderUI({
    tagList("We would be honored if you are interested in our work. The whole project including the data processing, attributes analysis and sentiment analysis has been uploaded to github. Your suggestions are welcome :", gitlink)
  })
}
shinyApp(ui, server)

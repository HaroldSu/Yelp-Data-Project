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
      summarize(counts_of_type = sum(counts), score_of_type = mean(score))
    
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
        summarize(counts_of_type = sum(counts), score_of_type = mean(score))
      
      if(length(index_business_match) != 0 & length(which(data_business_match$type == Type)) != 0){
        # Score of the matching business with a given type 
        score <- mean(data_business_match$score[data_business_match$type == Type])
        
        # Percentage of businesses whose score in the given type are lower than the matching business
        percent_better_than <- round(sum(data_grouped_by_type$score_of_type[data_grouped_by_type$type == Type] < score) 
                                     / dim(data_grouped_by_type[(data_grouped_by_type$type == Type),])[1] 
                                     * 100, digits = 1)
        
        # Histogram
        p <- hist(data_grouped_by_type$score_of_type[data_grouped_by_type$type == Type], freq = F,
                  main = Type,
                  cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
        abline(v = score, col = "red", lwd = 2)
        text_position_x_1 <- (min(p$breaks) + score) / 2
        text_position_x_2 <- (max(p$breaks) + score) / 2
        text_position_y <- max(p$density) * 0.8
        text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
             col = "red", cex = 1.2)
        text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|"),
             col = "red", cex = 1.2)
      }
    }else{
      if(length(which(data_business_match$key_word == Key)) != 0){
        score <- data_business_match$score[data_business_match$key_word == Key]
        percent_better_than <- round(sum(data$score[data$key_word == Key] < score) 
                                     / length(data$score[data$key_word == Key]) 
                                     * 100, digits = 1)
        
        # Histogram
        p <- hist(data$score[data$key_word == Key], freq = F,
                  main = Key,
                  cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
        abline(v = score, col = "red", lwd = 2)
        text_position_x_1 <- (min(p$breaks) + score) / 2
        text_position_x_2 <- (max(p$breaks) + score) / 2
        text_position_y <- max(p$density) * 0.8
        text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
             col = "red", cex = 1.2)
        text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|"),
             col = "red", cex = 1.2)
      }
    } 
  }else{
    if(Key != "SUMMARY" & length(which(data_business_match$key_word == Key)) != 0){
      score <- data_business_match$score[data_business_match$key_word == Key]
      percent_better_than <- round(sum(data$score[data$key_word == Key] < score) 
                                   / length(data$score[data$key_word == Key]) 
                                   * 100, digits = 1)
      
      # Histogram
      p <- hist(data$score[data$key_word == Key], freq = F,
                main = Key,
                cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
      abline(v = score, col = "red", lwd = 2)
      text_position_x_1 <- (min(p$breaks) + score) / 2
      text_position_x_2 <- (max(p$breaks) + score) / 2
      text_position_y <- max(p$density) * 0.8
      text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
           col = "red", cex = 1.2)
      text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", round((100 - percent_better_than), digits = 1), "%  >|"),
           col = "red", cex = 1.2)
    }
  }
}

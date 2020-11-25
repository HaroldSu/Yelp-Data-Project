rm(list = ls())

if(!require("dplyr")){
  install.packages("dplyr")
  stopifnot(require("dplyr"))
}

# Full data
data <- read.csv("./data/score.csv")

input_BusinessID <- data$business_id[1] # For test

# Data for the exact business
data_inputBusinessID <- data[(data$business_id == input_BusinessID), ]
# Data with scores of each type for every business
data_grouped_by_type <- data %>% 
  group_by(business_id, type) %>% 
  summarize(type_score = mean(score))


display <- function(Type = "service"){
  # Service
  if(Type == "service" | Type == "price"){
    if(Type %in% data_inputBusinessID$type){
      score <- mean(data_inputBusinessID$score[data_inputBusinessID$type == Type])
      count_of_Type <- sum(data_inputBusinessID$counts[data_inputBusinessID$type == Type])
      
      data_for_Type <- data_grouped_by_type %>% filter(type == Type)
      percent_better_than <- round(sum(data_for_Type$type_score < score) / dim(data_for_Type)[1] * 100, digits = 1)
      
      p <- hist(data_for_Type$type_score, freq = F, 
                main = Type, 
                cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
      abline(v = score, col = "red", lwd = 2)
      text_position_x_1 <- (min(p$breaks) + score) / 2
      text_position_x_2 <- (max(p$breaks) + score) / 2
      text_position_y <- max(p$density) * 0.8
      text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
           col = "red", cex = 1.2)
      text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", (100 - percent_better_than), "%  >|"),
           col = "red", cex = 1.2)
      print(paste0("Your ", Type, " score is ", round(score,digits = 2), ", given by totally ", count_of_Type, 
                  " reviews mentioning this aspect."))
      print(paste0("It is better than ", percent_better_than, "% of all ",
                   dim(data_for_Type)[1], " businesses, while the median score is ", 
                   round(median(data_for_Type$type_score),digits = 2)))
      }
  }
}



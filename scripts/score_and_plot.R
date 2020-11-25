if(!require("dplyr")){
  install.packages("dplyr")
  stopifnot(require("dplyr"))
}

key_word <- "beer" # Beer for example

data <- read.csv(file = paste0("data/demo/", key_word, ".csv"))
# stars_adjust
for(i in 1:dim(data)[1]){
  if(data$stars[i] == 5){
    data$stars_adjust[i] <- 5
  }else if(data$stars[i] == 1){
    data$stars_adjust[i] <- -5
  }else{
    data$stars_adjust[i] <- 0
  }
}

score_data <- data %>% 
  group_by(business_id) %>% 
  summarize(key_word = key_word, counts = n(), score = median((stars_adjust + sentiment * 10) / 2))








input_data <- score_data[1,] # First one in data for test

percent_better_than <- round(sum(score_data$score < input_data$score) / dim(score_data)[1] * 100, digits = 1)

# Histogram
p <- hist(score_data$score, freq = F, 
     main = paste0("In totally ", dim(score_data)[1], " businesses offering ", key_word, 
                   ", your position is shown as follows \n", 
                   "with ", input_data$counts, " reviews mentioning your business about it"), 
     cex.axis = 1.2, cex.lab = 1.2, xlab = "score", ylab = NA)
abline(v = input_data$score, col = "red", lwd = 2)
text_position_x_1 <- (min(p$breaks) + input_data$score) / 2
text_position_x_2 <- (max(p$breaks) + input_data$score) / 2
text_position_y <- max(p$density) * 0.8
text(x = text_position_x_1, y = text_position_y, labels = paste0("|<  ", percent_better_than, "%  >|"),
     col = "red", cex = 1.2)
text(x = text_position_x_2, y = text_position_y, labels = paste0("|<  ", (100 - percent_better_than), "%  >|"),
     col = "red", cex = 1.2)

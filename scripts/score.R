rm(list = ls())

if(!require("dplyr")){
  install.packages("dplyr")
  stopifnot(require("dplyr"))
}

data_list <- list()
types <- c("service", "price", "environment", "food_general", "food_specific")
for(m in 1:length(types)){
  type <- types[m]
  all.files <- list.files(path = paste0("./data/type/",type))
  key_words <- gsub(".csv","",all.files)
  data_list[[m]] <- data.frame()
  k <- 1
  for(key_word in key_words){
    data <- read.csv(file = paste0("data/type/",type,"/", key_word, ".csv"))
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
      summarize(type = type, key_word = key_word, 
                counts = n(), score = median((stars_adjust + sentiment * 10) / 2))
    if(k == 1){
      data_list[[m]] <- score_data
    }else{
      data_list[[m]] <- rbind(data_list[[m]], score_data)
    }
    k <- k + 1
  }
}

for(n in 1:length(data_list)){
  if(n == 1){
    data_grouped <- data_list[[n]]
  }else{
    data_grouped <- rbind(data_grouped, data_list[[n]])
  }
}

write.csv(data_grouped, file = "./data/score.csv", row.names = F)

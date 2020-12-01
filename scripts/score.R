rm(list = ls())

if(!require("dplyr")){
  install.packages("dplyr")
  stopifnot(require("dplyr"))
}

data_list <- list()
types <- c("service", "price", "environment", "food quality", "menu")
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
        data$stars_adjust[i] <- 1
      }else if(data$stars[i] == 1){
        data$stars_adjust[i] <- -1
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

data_business_name <- read.csv("./data/business_data_match_name.csv")

data_output <- left_join(data_grouped, data_business_name, by = "business_id")
write.csv(data_output, file = "./data/score.csv", row.names = F)

rm(list = ls())

if(!require("rjson")){
  install.packages("rjson")
  stopifnot(require("rjson"))
}
if(!require("jsonlite")){
  install.packages("jsonlite")
  stopifnot(require("jsonlite"))
}
if(!require("dplyr")){
  install.packages("dplyr")
  stopifnot(require("dplyr"))
}
if(!require("tidyverse")){
  install.packages("tidyverse")
  stopifnot(require("tidyverse"))
}
if(!require("tidytext")){
  install.packages("tidytext")
  stopifnot(require("tidytext"))
}

review_data <- jsonlite::stream_in(file("data/review_city.json"))
business_data <- jsonlite::stream_in(file("data/business_city.json"))

business_key_words <- c("pizza") # Key words of business to analyze
business_index_match <- c()
for(word in business_key_words){
  i <- grep(pattern = word, business_data$categories, ignore.case = T)
  business_index_match <- c(business_index_match, i)
}
business_index_match <- unique(business_index_match) # Indices of business matched

business_data_match <- business_data[business_index_match, ]
dim(business_data_match)[1] # Counts of business matched

review_data_match <- review_data[which( review_data$business_id %in% business_data_match$business_id), ]
dim(review_data_match)[1] # Counts of reviews matched

review_token <- review_data_match %>% 
  select(text) %>% 
  unnest_tokens(word, text)

data("stop_words")
review_token <- review_token %>% 
  anti_join(stop_words)

review_token_table <- review_token %>% 
  group_by(word) %>% 
  summarize(count = n())
review_token_table <- review_token_table[order(review_token_table$count, decreasing = T),]



review_token_table <- review_token_table[order(review_token_table)]
review_token_table <- review_token_table[(review_token_table$count >= 10), ]

write.csv(review_token_table, file = "data/word_freq.csv")

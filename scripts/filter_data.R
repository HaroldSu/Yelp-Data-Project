if(!require("rjson")){
  install.packages("rjson")
  stopifnot(require("rjson"))
}
if(!require("jsonlite")){
  install.packages("jsonlite")
  stopifnot(require("jsonlite"))
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

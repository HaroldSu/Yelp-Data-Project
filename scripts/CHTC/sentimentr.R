#  Import packages
if (require("sentimentr")) { 
  print("Loaded package sentimentr.")
} else {
  print("Failed to load package sentimentr.")  
}
if (require("tokenizers")) { 
  print("Loaded package tokenizers.")
} else {
  print("Failed to load package tokenizers.")  
}
if (require("tidyverse")) { 
  print("Loaded package tidyverse.")
} else {
  print("Failed to load package tidyverse.")  
}
if (require("readr")) { 
  print("Loaded package readr.")
} else {
  print("Failed to load package readr.")  
}


args = (commandArgs(trailingOnly=TRUE))
key_word = args[1]

review_data_match <- read_csv("review_data_match.csv")
review_data_match$text =  gsub("\\n", ". ", review_data_match$text)

#preprocess
sentences = tokenize_sentences(review_data_match$text)
sentences_stemed_tokenized = lapply(sentences, tokenize_word_stems)

#sentiment
sentences_stemed = list()
for (i in 1:length(sentences_stemed_tokenized)) {
  sentences_stemed[[i]] = 
    lapply(sentences_stemed_tokenized[[i]], paste, collapse = " ")
}

sentences_sentiment = list()
sentences_extract_sentiment_terms = list()

for (i in 1:length(sentences_stemed)) {
  
  sentences_sentiment[[i]] = 
    lapply(sentences_stemed[[i]], sentiment)
  
  sentences_extract_sentiment_terms[[i]] = 
    lapply(sentences_stemed[[i]], extract_sentiment_terms)
  
  print(i)
}


myfunction1 = function(business = "1YC7AbQMlNb5mLUlwwaa3w", keyword = key_word){
  #extrect needed info
  f_review_index = review_data_match$business_id == business
  f_sentences_stemed = sentences_stemed[f_review_index]
  f_sentences_stemed_tokenized = sentences_stemed_tokenized[f_review_index]
  #match sentence and stars, and do sentiment analysis
  tab = data.frame(sentence = vector(), 
                   stars = vector(), 
                   word_count = vector(), 
                   sentiment = vector())
  for (i in 1:length(f_sentences_stemed)) {
    for (j in 1:length(f_sentences_stemed[[i]])) {
      if (keyword %in% f_sentences_stemed_tokenized[[i]][[j]]){
        v = data.frame(sentence = f_sentences_stemed[[i]][[j]], 
                       stars = as.numeric(review_data_match$stars[f_review_index][i]), 
                       word_count = sentiment(f_sentences_stemed[[i]][[j]])$word_count, 
                       sentiment = sentiment(f_sentences_stemed[[i]][[j]])$sentiment)
        tab = rbind(tab, v)
      }
    }
  }
  return(tab)
}
testdata = myfunction1()
testdata_less0 = testdata[testdata$sentiment<0, ]

# (ADD A LINE FOR OUTPUT HERE)

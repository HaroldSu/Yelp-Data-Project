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
if (require("data.table")) { 
  print("Loaded package data.table")
} else {
  print("Failed to load package data.table")  
}

args = (commandArgs(trailingOnly=TRUE))
business = args[1]

review_data_match <- fread("review_data_match.csv", encoding = 'UTF-8')
keywords <- as.vector(t(fread("keyWords", encoding = 'UTF-8', header = F)))
print(length(keywords))
review_data_match = review_data_match[review_data_match$business_id == business, ]
print(nrow(review_data_match))

print("tokenizing")
#preprocess
sentences = tokenize_sentences(review_data_match$text)
sentences_stemed_tokenized = lapply(sentences, tokenize_word_stems)
sentences_stemed = list()
for (i in 1:length(sentences_stemed_tokenized)) {
  sentences_stemed[[i]] = 
    lapply(sentences_stemed_tokenized[[i]], paste, collapse = " ")
    print(i)
}

#sentiment
print("sentimenting")
myfunction2 = function(business, keyword){
  #extrect needed info
  f_review_index = (review_data_match$business_id == business)
  f_sentences_stemed = sentences_stemed[f_review_index]
  f_sentences_stemed_tokenized = sentences_stemed_tokenized[f_review_index]
  #match sentence and stars, and do sentiment analysis
  tab = data.frame(business_id = vector(),
                   Keyword = vector(), 
                   #sentence = vector(), 
                   word_count = vector(), 
                   stars = vector(), 
                   sentiment = vector())
  for (i in 1:length(f_sentences_stemed)) {
    for (j in 1:length(f_sentences_stemed[[i]])) {
      if (keyword %in% f_sentences_stemed_tokenized[[i]][[j]]){
        v = data.frame(business_id = business,
                       Keyword = keyword, 
                       #sentence = f_sentences_stemed[[i]][[j]], 
                       word_count = sentiment(f_sentences_stemed[[i]][[j]])$word_count, 
                       stars = as.numeric(review_data_match$stars[f_review_index][i]), 
                       sentiment = sentiment(f_sentences_stemed[[i]][[j]])$sentiment)
        tab = rbind(tab, v)
      }
    }
  }
  return(tab)
}

output_data = data.frame(business_id = vector(),
                         Keyword = vector(), 
                        #sentence = vector(), 
                        word_count = vector(), 
                        stars = vector(), 
                        sentiment = vector())
for (i in 1:length(keywords)) {
  output_data = rbind(output_data, myfunction2(business = business, keyword = keywords[i]))
  print(i)
}

write.csv(output_data, paste(business, ".csv", sep = ""))

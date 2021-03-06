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
key_word = args[1]

review_data_match <- fread("review_data_match.csv", encoding = 'UTF-8')
print(nrow(review_data_match))
all_business_id = unique(review_data_match$business_id)
print(length(all_business_id))

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
myfunction1 = function(business = "1YC7AbQMlNb5mLUlwwaa3w", keyword = key_word){
  #extrect needed info
  f_review_index = (review_data_match$business_id == business)
  f_sentences_stemed = sentences_stemed[f_review_index]
  f_sentences_stemed_tokenized = sentences_stemed_tokenized[f_review_index]
  #match sentence and stars, and do sentiment analysis
  tab = data.frame(business_id = vector(),
                   #sentence = vector(), 
                   word_count = vector(), 
                   stars = vector(), 
                   sentiment = vector())
  for (i in 1:length(f_sentences_stemed)) {
    for (j in 1:length(f_sentences_stemed[[i]])) {
      if (keyword %in% f_sentences_stemed_tokenized[[i]][[j]]){
        v = data.frame(business_id = business,
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
                       #sentence = vector(), 
                       word_count = vector(), 
                       stars = vector(), 
                       sentiment = vector())
for (i in 1:length(all_business_id)) {
  output_data = rbind(output_data, myfunction1(business = all_business_id[i], keyword = key_word))
  print(i)
}

write.csv(output_data, paste(key_word, ".csv", sep = ""))

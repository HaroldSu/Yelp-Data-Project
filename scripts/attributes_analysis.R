# setwd("~/Desktop/STAT628/3Yelp_Data_Project")

if(!require("dplyr")){
  install.packages("dplyr")
  stopifnot(require("dplyr"))
}
if(!require("RVAideMemoire")){
  install.packages("RVAideMemoire")
  stopifnot(require("RVAideMemoire"))
}
if(!require("coin")){
  install.packages("coin")
  stopifnot(require("coin"))
}
if(!require("rcompanion")){
  install.packages("rcompanion")
  stopifnot(require("rcompanion"))
}

business_attributes <- business_data_match$attributes
n1 <- ncol(business_attributes)
n2 <- nrow(business_attributes)
n3 <- nrow(review_data_match)

## Delete columns with only non-NA observes less than 1
index <- c()
for(i in 1:n1){
  if(length(na.omit(business_attributes[,i])) <= 1 ){ index=c(index,i) }
}
business_attributes[ ,index] = NULL

attr_col = colnames(business_attributes)
business_attributes <- cbind(business_data_match$business_id, business_data_match$review_count, business_data_match$stars, business_attributes)
colnames(business_attributes) = c("business_id", "review_count", "ave_stars", attr_col)

o <- order(business_attributes$business_id)
business_attributes <- business_attributes[o,]

o <- order(review_data_match$business_id)
review_data_match <- review_data_match[o,]

# review_stars <- cbind(review_data_match$business_id, review_data_match$stars)
# colnames(review_stars) <- c("business_id", "stars")
# o <- order(review_stars[,1])
# review_stars <- review_stars[o,]


## Matching each review star with attributes of the restuarant corresponding to the business_id(really really slow:(
attr_star_col = c("business_id", "stars", attr_col) 
mat = matrix(nrow=0,ncol=length(attr_star_col))
attr_star = as.data.frame(mat)
colnames(attr_star) = attr_star_col
t = 1
for(i in 1:n2){
  for(j in t:n3)
    if(business_attributes$business_id[i] == review_data_match$business_id[j]){
      nwrow = c(review_data_match$business_id[j],review_data_match$stars[j],business_attributes[i,-1:-3])
      nwdat = data.frame(nwrow)
      colnames(nwdat) = attr_star_col
      attr_star = rbind(attr_star, nwdat)
      t = j+1
    }else{
      next
    }
}

## Viewing the "unrefined" contengency table
# for(i in 1:(length(colnames(attr_star))-2)){
#   t = table(attr_star$stars, attr_star[,i+2])
#   print(i+2)
#   print(t)
# }


##  Kruskal–Wallis test
test_result <- c()
for(i in c(4,5,7,8,9,11,12,14,15,16,17,18,19,22,24,25,26,27,28,29,33,34,3,6,13,20,32,35)){
  test_attr_star <- attr_star[,c(2,i)]
  test_attr_star[,2] <- sub("u\'","\'",test_attr_star[,2])
  test_attr_star[,2] <- gsub("\'","",test_attr_star[,2])
  name <- colnames(test_attr_star)[2]
  cat(i,name,"\n",sep = "\t")
  test_attr_star[,2] <- as.factor(test_attr_star[,2])
  group_by(test_attr_star, test_attr_star[,2]) %>%
    summarise(
      count = n(),
      mean = mean(stars, na.rm = TRUE),
      sd = sd(stars, na.rm = TRUE),
      median = median(stars, na.rm = TRUE),
      IQR = IQR(stars, na.rm = TRUE),
      .groups = 'drop'
    ) %>% print()
  k <- kruskal.test(stars ~ test_attr_star[,2], data = test_attr_star)
  print(k)
  test_result <- c(test_result, name, k$statistic, k$p.value)
}
(test_result <- matrix(test_result, ncol = 3, byrow = TRUE))
test_result <- data.frame(test_result,row.names = NULL)
colnames(test_result) <- c("Attribute","Kruskal-Wallis rank sum statistic","p-value")
write.csv(test_result,"./data/attr_test_result.csv")


## Take attribute "WiFi" as an example
Wifi_star <- attr_star[,c(2,20)]
Wifi_star[,2] <- sub("u\'","\'",Wifi_star[,2])
Wifi_star[,2] <- gsub("\'","",Wifi_star[,2])
name <- colnames(Wifi_star)[2]
Wifi_star[,2] <- as.factor(Wifi_star[,2])
cat(name,"\n",sep = "\t")
group_by(Wifi_star, Wifi_star$WiFi) %>%
  summarise(
    count = n(),
    mean = mean(stars, na.rm = TRUE),
    sd = sd(stars, na.rm = TRUE),
    median = median(stars, na.rm = TRUE),
    IQR = IQR(stars, na.rm = TRUE),
    .groups = 'drop'
  ) %>% print()
(kruskal.test(stars ~ WiFi, data = Wifi_star))
library("ggpubr")
ggboxplot(na.omit(Wifi_star), x = "WiFi", y = "stars", 
          color = "WiFi", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("paid","free","no"),
          ylab = "Stars", xlab = "Treatment(WiFi)")



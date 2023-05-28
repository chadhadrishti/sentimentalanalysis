#set directory
setwd("~/Desktop/Sentimental Analysis")
rm(list=ls()) #remove all variables previously stored
#install.packages("ggplot2")
#install.packages("splitstackshape")
#install.packages("tidytext")
#install.packages("RODBC")
#--Read excel file downloaded from kaggle

data <- read_excel("~/Downloads/reddit_vm.xlsx")
names(data)
#Start Split of text
#Make sure your columns are explicit because it is case sensitive
library(splitstackshape)
CareData <- cSplit(data,"body", sep =" ", direction = "long")
#creating more special character separators
CareData <- cSplit(CareData,"body",sep="/",direction = "long")
CareData

names(CareData) <- c("title","score","id","url","comms_num","created","word","timestamp") #changing body name to word

#-Cleaning special characters
#DF$[Name] adds column
CareData$word <- gsub(",$", "",CareData$word)
CareData$word <- gsub(":", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("\"", "",CareData$word, fixed=TRUE)
CareData$word <- gsub(";", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("!", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("?", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("-", "",CareData$word, fixed=TRUE)
CareData$word <- gsub(".", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("/", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("\\", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("(", "",CareData$word, fixed=TRUE)
CareData$word <- gsub(">", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("<", "",CareData$word, fixed=TRUE)
CareData$word <- gsub(")", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("#", "",CareData$word, fixed=TRUE)
CareData$word <- gsub("\r\n\r\nü§¶‚Äç‚ôÇÔ∏èü§¶‚Äç‚ôÇÔ∏è", "",CareData$word, fixed=TRUE)


library(dplyr)
library(tidytext)

#data(stop_words)
#show most common words
tail(names(sort(table(CareData$word))),10000000000000000000000000000000)

#Test Sentiments lists
#sentiments
get_sentiments("bing") #"nrc" & "afinn"

#Convert to tibble
CareTibble <- as_data_frame(CareData)
class(CareTibble)
CareTibble

#Join DF to Bing sentiment
library(dplyr)
CareTibbleBing <- CareTibble %>%
  inner_join(get_sentiments("bing"))
library(dplyr)
sentiment_data<-count(CareTibbleBing,CareTibbleBing$sentiment)
#?dplyr:count browseVignettes(package = "dplyr")
#Count by word sentiment
CareTibCount <- CareTibbleBing %>% count(score,word,sentiment,sort = TRUE)
CareTibCount
#bar chart
library(ggplot2)
#group by score
CareTibCount %>%
  group_by(sentiment) %>%
  top_n(25) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(score, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Count to sentiment",
       x = NULL) +
  coord_flip()
#pie 
library(ggplot)
sentiment_data
pie(sentiment_data$n, labels = c("positive","negative"),main="Pie chart of sentiments towards vaccination")

#Word Cloud
install.packages("wordcloud")
install.packages("reshape2")
library(wordcloud)
library(reshape2)

CareTibbleBing <-CareTibbleBing %>%
  with(CareTibbleBing, !(word =="issue"))

#Basic Wordcloud
library(ggplot)
CareTibbleBing %>%
  with(CareTibbleBing, !(word =="issue"))%>%
  anti_join (stop_words) %>%
  count(word) %>%
  with (wordcloud(word, n, max.words = 100))


#Wordcloud group +-
CareTibbleBing %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D","#00BFC4"),
                   max.words = 100)


aggregate(CareTibCount$n, by=list(Category=CareTibCount$crmReasonOne,Sentiment=CareTibCount$sentiment), FUN=sum,
         negative.rm=TRUE)


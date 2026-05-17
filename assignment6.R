library(dplyr)
library(tidyr)

#1a.prepare speeches.csv
original_speeches <- read.csv("speeches.csv", sep='|', quote="")
#! removes NA, select date and contents
speeches <- original_speeches[!is.na(speeches$contents), c("date","contents")]
#change type of content
speeches$date <- as.Date(speeches$date)
#summarise() creates a new data frame. It returns one row for each combination of grouping variables (date in this case). 
#collapse="separator in new data frame" 
# => how you want to combine many rows into one, which merges same date speeches
speeches <- speeches %>% 
  summarise(contents=paste(contents,collapse=" "),.by = date)

#1b.prepare fx.csv
original_fx <- read.csv("fx.csv")
#select the first and third columns
fx <- original_fx[c(1,3)]
#change column names
colnames(fx) <- c("date", "exchange_rate")
#ensure right type of constant
fx$date <- as.Date(fx$date)
fx$exchange_rate <- as.numeric(fx$exchange_rate)

#1c.merge speeches and fx
df <- fx %>% left_join(speeches, by= "date")

#2.check for any obvious outliers or mistakes by plotting the data
plot(df$date, df$exchange_rate, type='l', xlab="date", ylab="EUR/USD reference exchange rate")

#3.fill missing rate
df2 <- df
df2 <- df2 %>% 
  fill(exchange_rate, .direction="down")

#4a.compute exchange rate returns
#lag shifts the whole data set to take the previous value
df2$return <- (df2$exchange_rate - lag(df2$exchange_rate)) / lag(df2$exchange_rate)

#4b.assign good and bad news
df2$good_news <- as.numeric(df2$return > 0.5/100)
df2$bad_news <- as.numeric(df2$return < -0.5/100)

#5a.remove NA content rows
df2 <- df2 %>% 
  drop_na(contents)

#5b.collate good news content and bad news content
good_news_contents <- df2$contents[df2$good_news==1]
bad_news_contents <- df2$contents[df2$bad_news==1]

#5c.load in stop words, which are those used to form a sentence but does not add much meaning
#header=false ensures first word doesn't become the header
stop_words <- read.csv("stop_words_english.txt", header = FALSE)

#5d.create function to collate common words
library(text2vec)
get_word_freq <- function(contents, stop_words, num_words) {
  words <- unlist(lapply(contents, word_tokenizer))  
  words <- tolower(words)  
  freq <- table(words)
  freq <- freq[!(names(freq) %in% stop_words)]
  freq <- sort(freq, decreasing=TRUE)
  return(names(freq)[1:num_words])
}

#5e.use function
good_indicators <- get_word_freq(good_news_contents, stop_words, num_words = 20)
bad_indicators <- get_word_freq(bad_news_contents, stop_words, num_words = 20)
good_indicators
bad_indicators
#Observation: Many terms appear in both, some overlapping
rm(list=ls())
library(tidyverse)
library(tidytext)
library(rtweet)

# get twitter handles for each candidate
candidates <- c('@CoryBooker','@PeteButtigieg','@JulianCastro',
                '@JohnKDelaney','@TulsiGabbard','@SenGillibrand',
                '@KamalaHarris','@amyklobuchar','@ewarren')


# get most recent 3200 tweets for each candidate
# tweets_2020_cands <- get_timelines(candidates, n = 3200, retryonratelimit =TRUE) # uncomment if not already downloaded
load('data/2019_02_15_2020_twitter_primary.RData')

# filter dataset to tweets from Jan 1
since_jan <- tweets_2020_cands %>%
  filter(created_at > ymd('2019-01-01'))

# no retweets or replies
since_jan <- since_jan %>%
  filter(is.na(reply_to_status_id),
          is.na(retweet_status_id)) 

# get cumulative number of tweetss
cumul_tweets <- since_jan %>%
  group_by(screen_name) %>%
  summarise(num_tweets = n())


# plot
gg <- ggplot(cumul_tweets,aes(x=reorder(screen_name,num_tweets),
                              y=num_tweets,col=screen_name,fill=screen_name)) +
  geom_col(alpha=0.8) +
  scale_color_pander() +
  scale_fill_pander() +
  theme(legend.position = 'none') +
  coord_flip() +
  labs(title="Kamala Harris is Winning the Social Media Primary",
       subtitle="...for whatever that's worth",
       x="Candidate",
       y="Cumulative Number of Tweets\n(Since Jan. 1, 2018)",
       caption="Source: Tweets scraped using @kearneymw `rtweet` package")
       

library(tidytext)
bing <- get_sentiments("bing")

# initial text cleaning and word tokens
remove_reg <- "&amp;|&lt;|&gt;"

tidy_tweets <- since_jan %>% 
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word,
         !word %in% str_remove_all(stop_words$word, "'"),
         str_detect(word, "[a-z]"))

# remove stop words, do some other cleaning
tidy_tweets <- tidy_tweets %>%
  anti_join(stop_words) %>%
  filter(str_detect(word, "[a-z]"))

# match to bing lexicon so we only get real words
tidy_tweets.bing <- tidy_tweets %>%
  inner_join(bing, by = "word")

# look at frequencies
tidy_tweets.bing %>%
  group_by(screen_name) %>%
  count(word) %>%
  arrange(desc(n)) %>%
  summarise(most_frequent_word = first(word)) %>%
  kable()
  
  
# grouped positive/negative by word
sentiments_counts <- tidy_tweets.bing %>%
  group_by(screen_name,word) %>%
  count(sentiment) %>%
  arrange(-n)

# positive freqquency
pos_neg <-  sentiments_counts %>%
  group_by(screen_name,sentiment) %>%
  summarise(n = sum(n)) %>%
  as.data.frame() %>%
  group_by(screen_name) %>%
  mutate(freq = case_when(sentiment=="positive" ~n/sum(n))) %>%
  filter(!is.na(freq))

# plot
gg <- ggplot(pos_neg,aes(x=reorder(screen_name,freq),
                              y=freq,col=screen_name,fill=screen_name)) +
  geom_col(alpha=0.8) +
  scale_color_pander() +
  scale_fill_pander() +
  theme(legend.position = 'none') +
  coord_flip() +
  labs(title="The 2020 Democratic Candidates Are Pretty\nEvenly Positive/Negative on Twitter",
       subtitle="Their word usage doens't differ that much",
       x="Candidate",
       y="Percentage of Total Words That Are Positive",
       caption="Source: Tweets scraped using @kearneymw `rtweet` package")

print(gg)

nrc <- get_sentiments("nrc")

# sentiment by candidate
tidy_tweets.nrc <- tidy_tweets %>%
  # match to lexicon
  inner_join(nrc, by = "word")

# grouped positive/negative by word
emotions <- tidy_tweets.nrc %>%
  group_by(screen_name,word) %>%
  count(sentiment) %>%
  arrange(-n)

# grequency of each emotion
nrc_grouped <- emotions %>%
  group_by(screen_name) %>%
  count(sentiment, sort = TRUE) %>%
  mutate(freq = n/sum(n)) %>%
  as.data.frame() %>%
  filter(!sentiment %in% c('positive','negative','anticipation','surprise'))

gg <- ggplot(nrc_grouped,aes(x=reorder(screen_name,freq),y=freq,col=screen_name,fill=screen_name)) +
  geom_col(alpha=0.8) +
  facet_wrap(~sentiment,scales = 'free_x',ncol=3,nrow=3) +
  coord_flip() +
  labs(title="A Mixed Bag of Emotions",
       subtitle="Some small differences, but no real outliers, in the 2020 candidates' online emotions",
       x="Candidate",
       y="Percentage of Total Words",
       caption="Source: Tweets scraped using @kearneymw `rtweet` package")

print(gg)
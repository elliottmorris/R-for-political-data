rm(list=ls())
library(gtrendsR)
library(rtweet)
library(tidyverse)


# #YangGang google trends list data (and another keyword to compare to)
search <- gtrends(keyword = c("Yang","Sanders"), geo = "US" ,time=paste("2019-01-01",Sys.Date()))

# get the trend 
overtime <- search$interest_over_time

# plot it
ggplot(overtime,aes(x=date,y=hits,col=keyword)) + 
  geom_line() +
  scale_colour_brewer(name="Keyword",palette = "Dark2") +
  labs(title="How Much Interest Is There In Andrew Yang?",
       subtitle="As measured by google trends data*",
       x="Date",
       y="Relative Search Volume",
       caption="*Which introduces plenty of measurement error") +
  theme_minimal()


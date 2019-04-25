# vignette = https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
# more = http://tidytextmining.com/_book/intro.html

# setup -------------
library(newsflash) # devtools::install_github("hrbrmstr/newsflash")
library(tidyverse)
library(tidytext) #devtools::install_github("juliasilge/tidytext")
library(lubridate)
library(stringi)

# data from last x days --------
ENDDATE   <- ymd("2019-03-17")
STARTDATE <- ymd("2019-03-14")

days <- seq(from=STARTDATE,
            to=ENDDATE,
            by = "days"
)


# chryons -------
chyrons_objects <- as.data.frame(list_chyrons()) %>% 
  filter(ts %in% days, type == "cleaned")

chyrons <- data.frame(NULL)
# uncomment these lines if you haven't downloaded the data yet. I'm commenting and loading to save time:
# for(i in 1:nrow(chyrons_objects)){
#   #print(paste("Fetching chyrons for ",chyrons_objects[i,]$ts))
#   chyrons <- chyrons %>%
#     bind_rows(read_chyrons(chyrons_objects[i,]$ts) %>%
#                 mutate(channel = gsub("BBCNEWS","BBC",channel),
#                        channel = gsub("CNNW","CNN",channel),
#                        channel = gsub("MSNBCW","MSNBC",channel),
#                        channel = gsub("FOXNEWSW","FOX",channel)) %>% 
#                 filter(channel %in% c("CNN","MSNBC","FOX"))
#     )
# }

# load the data (comment out if you haven't downloaded yet)
load(file='data/2019_03_15_beto_media_data.RData')


# tokenize words ----------
# get words
chyrons <- chyrons %>% 
  unnest_tokens(word, text,drop = FALSE)


# drop stop words
data("stop_words")
chyrons <- chyrons %>%
  anti_join(stop_words)


# analye --------
# most used words? 
chyrons %>% 
  count(word, sort=TRUE)


# example --------
# need to get words
mention_chyron <- chyrons %>% 
  mutate(date = date(ts),
         hour = hour(ts),
         time = paste0(date," ",hour,":00:00"),
         text = tolower(as.character(text)),
         mention = grepl("beto|o\'rourke", text))  

# percentage of words by channel ---------

# frequency only of keyword mentions
mention_chyron_n <- mention_chyron %>%
  filter(mention) %>% 
  count(time, channel) 

mention_by_time_chyron <- left_join(
  mention_chyron_n, 
  mention_chyron  %>%
    group_by(time, channel) %>%
    summarise(total = n()) %>%
    #mutate(time = as_datetime(time,tz="US/Central")) %>%
    select(time,channel,total)
) %>% 
  mutate(n = n/total)

# datetime object for candidate
mention_by_time_chyron <- mention_by_time_chyron %>%
  mutate(time = as_datetime(time))

# graph
gg <- ggplot(mention_by_time_chyron,aes(x=time, y=n, col=channel,fill=channel)) +
  geom_col() + 
  scale_y_continuous(labels = scales::percent_format()) +
  scale_x_datetime(date_labels = "%b %d %I%p",expand = expand_scale(0.1)) + 
  facet_wrap(~channel, scales="fixed",ncol = 1) +
  labs(title="Cable News Outlets Hand Microphone to Beto O'Rourke",
       subtitle="Counting mentions of the candidate in cable networks' scrolling chyrons",
       caption="Source: Internet Archive Third Eye project",
       x="Date",
       y="Percent of Hourly Mentions") +
  theme(legend.position="bottom") +
  scale_color_manual("Network",values=c("CNN"="#F8C471","FOX"="#EC7063","MSNBC"="#5DADE2","BBC"="#D2B4DE")) +
  scale_fill_manual("Network",values=c("CNN"="#F8C471","FOX"="#EC7063","MSNBC"="#5DADE2","BBC"="#D2B4DE")) +
  coord_cartesian(ylim=c(0,max(mention_by_time_chyron$n)))

print(gg)





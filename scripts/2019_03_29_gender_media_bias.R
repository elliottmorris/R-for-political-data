# vignette = https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
# more = http://tidytextmining.com/_book/intro.html

# setup -------------
library(newsflash) # devtools::install_github("hrbrmstr/newsflash")
library(tidyverse)
library(tidytext) #devtools::install_github("juliasilge/tidytext")
library(lubridate)
library(stringi)
library(ggthemes) #devtools::install_github("jrnold/ggthemes")

# data from last x days --------
ENDDATE   <- ymd("2019-03-17")
STARTDATE <- ymd("2019-01-01")

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
#save(chyrons, file='data/2019_03_29_2020_media_gender_bias.RData')
load(file='data/2019_03_29_2020_media_gender_bias.RData')


# tokenize words ----------
# get words
chyrons <- chyrons %>% 
  unnest_tokens(word, text,drop = FALSE)


# drop stop words
data("stop_words")
chyrons <- chyrons %>%
  anti_join(stop_words)


# get mentions for each candidate -----------------------------------------
# need to get words
mention_chyron <- chyrons %>% 
  mutate(date = date(ts),
         hour = hour(ts),
         time = paste0(date," ",hour,":00:00"),
         text = tolower(as.character(text)),
         # trump
         #trump_mention = grepl("trump",text),
         # declared dems
         castro_mention = grepl("castro",text),
         warren_mention = grepl("warren",text),
         gabbard_mention = grepl("gabbard",text),
         gillibrand_mention = grepl("gillibrand",text),
         harris_mention = grepl("harris", text),
         buttigieg_mention = grepl("buttigieg|pete",text),
         booker_mention = grepl("booker",text),
         sanders_mention = grepl("sanders",text),
         klobuchar_mention = grepl("klobuchar",text),
         inslee_mention = grepl("inslee",text),
         hickenlooper_mention = grepl("hickenlooper",text),
         orourke_mention = grepl("o\'rourke",text),
         # undeclared dems
         biden_mention = grepl("biden",text)
  )  

mention_chyron <- mention_chyron %>%
  gather(candidate,mention,10:22) %>%
  mutate(candidate = gsub('_mention','',candidate)) %>% 
  filter(candidate != "trump")

mention_chyron_n <- mention_chyron %>%
  filter(mention) %>% 
  count(date, candidate) 

mention_by_time_chyron <- left_join(
  mention_chyron_n, 
  mention_chyron  %>%
    group_by(date, candidate) %>%
    summarise(total = n()) %>%
    #mutate(time = as_datetime(time,tz="US/Central")) %>%
    select(date,candidate,total)
) %>% 
  mutate(n = n/total) %>%
  as.data.frame()

# clone
mention_elapsed <- mention_by_time_chyron 

# if no mention for candidate on that day, set to 0
daily_total <- mention_chyron  %>%
  group_by(date) %>%
  summarise(total = n()) 

mention_elapsed <- mention_elapsed %>%
  bind_rows(
    lapply(unique(mention_elapsed$candidate),
           function(x){
             print(x)
             # get dates
             dates = mention_elapsed %>%
               filter(candidate == x) %>% 
               pull(date) %>% unique()
             
             # get dates not in dates
             append_dates <- seq.Date(min(daily_total$date),max(daily_total$date),by='day') 
             append_dates <- append_dates[!append_dates %in% dates]
             
             # bind to df
             append_data <- data.frame(date=append_dates,stringsAsFactors = F) %>% mutate(candidate=x,n=0)
             
             append_data$total <- daily_total[match(append_data$date,daily_total$date),]$total
             
             return(append_data)
           }
    ) %>% do.call('bind_rows',.)
  )

# bias? male vs female ----------------------------------------------------
mentions_by_sex <- mention_elapsed %>%
  mutate(gender = ifelse(candidate %in% c('warren','gabbard','gillibrand','harris','klobuchar'),'Men','Women')) %>%
  group_by(date,gender) %>% 
  summarise(n=sum(n))


gg <- ggplot(mentions_by_sex %>% mutate(n=n/sum(n)),
             aes(x=date, y=n, fill=gender,group=gender)) +
  geom_col(position=position_stack(),width=1) +
  geom_hline(yintercept = 0.5,linetype=2,col='gray80') +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_minimal() +
  scale_fill_ptol(name='Gender') +
  labs(title="Has 2020 Coverage Been Biased By Gender?",
       subtitle="Counting mentions of the candidate in cable networks' scrolling chyrons",
       caption="Source: Internet Archive Third Eye project",
       x="Days Before/After Announcement",
       y="Percent of Daily Mentions") 

print(gg)

# bias by month
mentions_by_sex %>%
  group_by(gender,month=ymd(paste0(year(date),'-',month(date),'-01'))) %>%
  summarise(n = sum(n)) %>%
  group_by(month) %>%
  mutate(n = n/sum(n)) 

# total
mentions_by_sex %>%
  group_by(gender) %>%
  summarise(n = sum(n)) %>%
  mutate(prop = n/sum(n))




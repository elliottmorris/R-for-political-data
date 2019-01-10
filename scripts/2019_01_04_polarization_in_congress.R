library(tidyverse)
library(knitr)
library(kableExtra)

# read in the data
house_ideo <- read_csv("https://voteview.com/static/data/out/members/Hall_members.csv")

# filter the data just for Democrats (100) and Republicans (200), and recode
# also, only keep for congresses after 1960 (the 89th)
house_ideo <- house_ideo %>%
  filter(party_code %in% c(100,200),congress>89) %>%
  mutate(party = case_when(party_code == 100 ~ "Democratic",
                           party_code == 200 ~ "Republican"))

# compute median ideology for each year
ideo <- house_ideo %>%
  group_by(congress,party) %>%
  summarise(ideo = median(nominate_dim1,na.rm=T))

# create a measure of distance between the median member
distance <- ideo %>%
  spread(party, ideo) %>%
  mutate(distance = abs(Democratic - Republican))

# make a table
distance %>% 
  arrange(desc(distance)) %>%
  kable(caption = "Distance Between Median Dem. and Rep. House Member Ideology") %>%
  kable_styling(bootstrap_options =  "hover")

ggplot(distance, aes(x=congress,y=distance)) +
  geom_line() +
  labs(title="Polarization Between House Members, 1960-2018",
       x="Congress",
       y="Distance between Median Member's Ideology") +
  theme_minimal()

library(ggridges)

ggplot(house_ideo,aes(x=nominate_dim1,y=as.factor(congress),fill=party)) +
  ggridges::geom_density_ridges2(rel_min_height = 0.05,col=NA,scale=4,alpha=0.5) +
  scale_fill_manual(values=c("Democratic"="blue","Republican"="red")) +
  labs(title="Polarization Between House Members, 1960-2018",
       x="Ideology (DW-NOMINATE)",
       y="Congress") +
  theme_minimal()
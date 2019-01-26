library(tidyverse)
library(knitr)
library(kableExtra)
library(ggrepel)
library(ggExtra)

# read in the data
house_ideo <- read_csv("https://voteview.com/static/data/out/members/Hall_members.csv")

# filter the data just for Democrats (100) and Republicans (200), and recode
# also, only keep for the present congress (116th)
house_ideo <- house_ideo %>%
  filter(congress==116) %>%
  mutate(party = case_when(party_code == 100 ~ "Democratic",
                           party_code == 200 ~ "Republican"))

# plot the dim 1 and 2, single out AOC
gg <- ggplot(house_ideo,
       aes(x=nominate_dim1,y=nominate_dim2,col=party)) +
  geom_point() +
  geom_label_repel(data=house_ideo %>% filter(grepl("ocasio",tolower(bioname))),
             label='Ocasio-Cortez',show.legend = F,nudge_x=0.15,min.segment.length = 0.01) +
  theme_minimal() +
  scale_color_manual("Party",values=c("Republican"="#E74C3C","Democratic"="#3498DB")) +
  labs(x="DW-NOMINATE Ideology\n(Dimension 1)",
       y="DW-NOMINATE Ideology\n(Dimension 2)",
       title="Ocasio-Cortez Doesn't Look So Socialist",
       subtitle="Could this be due to a weakness in algorithms that are based on roll call votes",
       caption="Source: VoteView.com") +
  theme(legend.position = 'none')


# add the marginal histogram
ggMarginal(gg, type = "histogram",groupFill = TRUE,colour=NA)

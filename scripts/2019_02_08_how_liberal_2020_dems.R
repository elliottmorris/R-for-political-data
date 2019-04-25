rm(list=ls())
source("~/setup_elliott.R")

# You need: library(tidyverse); library(ggalt); library(ggthemes)

# read in file of candidate ideologies
cand_ideo <- read_csv("../../data_no_export/post/2019_02_08_how-liberal-2020-dems/2019_02_08_how-liberal-2020-dems.csv")

# scale to -1,1
cand_ideo <- cand_ideo %>%
  mutate(economic = rescale(economic,c(-1,1),c(0,1)),
         social = rescale(social,c(-1,1),c(0,1)))

# summary stats
cand_ideo %>%
  group_by(year) %>% 
  summarise(social = median(social),
            economic = median(economic)) %>%
  kable()

# plot
gg <- ggplot(cand_ideo, aes(x = economic, y = social, col=as.factor(year),fill=as.factor(year))) +
  geom_vline(xintercept = 0,linetype=2) +
  geom_hline(yintercept = 0,linetype=2) +
  geom_point(size=2) +
  coord_cartesian(xlim=c(-1, 1),
                  ylim=c(-1, 1)) +
  stat_bkde2d(bandwidth = c(0.15, 0.15),aes(alpha = (..level../1)*0.5), geom = "polygon",show.legend = F) +
  scale_color_wsj() +
  scale_fill_wsj() +
  guides("color"=guide_legend(title="Year"),
        "fill"="none")  +
  labs(title="2020 Democrats Look Ideologically Similar to Their Predecessors",
       subtitle="Coverage painting the 2020 candidates as record-setting liberals is unwarranted. Each point is a candidate.",
       x="Position on Economic Issues\n(-1=Liberal, 1=Conservative)",
       y="Position on Social Issues\n(-1=Liberal, 1=Conservative)",
       caption="Source: OnTheIssues.org")

gg
source("~/setup_elliott.R")

poll <- read_csv("~/Desktop/cnn 2020 poll.csv")

head(poll)

gg <- ggplot(poll,aes(x=name.rec,y=fav.min.unfav,label=candidate)) +
  geom_point(col='blue',size=2,alpha=0.8) + 
  geom_label_repel() +
  geom_smooth(method='lm',se=F,linetype=2,col='orange') +
  labs(title="All Press is (Mostly) Good Press",
       subtitle="In polls of the 2020 Democratic nomination, better-known candidates have higher favorability ratings",
       x="Percent with Opinion about Candidate",
       y="Net Favorability",
       caption="Source: CNN/SSRS Poll")

preview(gg)

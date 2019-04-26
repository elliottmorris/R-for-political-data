# vignette = https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
# more = http://tidytextmining.com/_book/intro.html

# setup -------------
library(newsflash) # devtools::install_github("hrbrmstr/newsflash")
library(tidyverse)
library(tidytext) #devtools::install_github("juliasilge/tidytext")
library(lubridate)
library(stringi)
library(ggthemes) #devtools::install_github("jrnold/ggthemes")
library(ggrepel)


# read in data and plot ---------------------------------------------------
predictit <- read_csv("data/2019_04_12_mayor_pete_hype.csv")

predictit <- predictit %>% 
  filter(ContractName %in% c("Sanders","Biden","Buttigieg","Harris","O'Rourke","Warren"))

# plot
gg <- ggplot(predictit,aes(x=mdy(DateString),y=Price,
                     col=ContractName,
                     group=ContractName)) +
  geom_point(alpha=0.25) +
  geom_smooth(method='gam',formula=y~s(x),se=F,size=1) +
  geom_text_repel(data=predictit %>% filter(mdy(DateString) == max(mdy(predictit$DateString))),
                  aes(label=ContractName),
                  show.legend = F,min.segment.length = 20,
                  nudge_x = 3) +
  #scale_color_stata('s1color') +
  scale_x_date(date_labels = "%b. '%d",limits = c(ymd('2019-01-01',Sys.Date()+10))) +
  scale_y_continuous(limits = c(0,0.3)) +
  theme_minimal() +
  theme(legend.position = 'none') +
  labs(title="Odds of Winning The 2020 Democratic Nomination*",
       subtitle="The Buttigieg Bounce (or is it a bump?)",
       x="Date",
       y="Market price for winning\nthe 2020 Democratic nomination",
       caption="*For candidates tracking about 5%\nSource: PredictIt")


print(gg)



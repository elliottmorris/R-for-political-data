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


# analysis ----------------------------------------------------------------
age_brackets <- data.frame(Generation = c("Silent Generation","Baby Boomers","Generation X","Millennials","Generation Z"),
                           start = c(1928,1946,1965,1981,1997),
                           end = c(1945,1964,1980,1996,as.numeric(year(Sys.Date()))),stringsAsFactors = F)

candidates <- read_csv("data/2019_04_05_how_young_2020_democrats.csv")

# attach the generation to all candidates' entry
candidates$Generation <- 
  lapply(candidates$year,
         function(x){
           age_brackets %>% 
             filter(start <= x, end >= x) %>%
             pull(Generation)
         }) %>% do.call('c',.)

# plot
gg <- ggplot() +
  geom_segment(data=age_brackets %>% filter(start<1996),
               aes(x=start,xend=end,
                   y=reorder(Generation,start),yend=reorder(Generation,start),
                   col=Generation),size=1.5,alpha=0.5) +
  geom_point(data=candidates,
             aes(x=year,y=Generation,col=Generation)) +
  geom_label_repel(data=candidates,
                   aes(x=year,y=Generation,label=candidate,
                       col=Generation),
                   show.legend = F) +
  theme_minimal() +
  labs(title="2020 Democratic Candidates By Age",
       x="Year",
       y="",
       subtitle="  ") +
  theme(legend.position = 'none')

print(gg)



rm(list=ls())
source("~/setup_elliott.R")

# read in 2018 data
results_2018 <- read_csv("~/Dropbox/Projects/R for political data/data/2019_03_01_2018_vs_partisanship.csv")


# compute partisan lean for each state
pres <- politicaldata::pres_results

pres <- pres %>% 
  filter(year %in% 2012:2016)

pres <- pres %>%
  select(state, year,dem,rep)

pres <- pres %>%
  gather(party,vote,3:4) %>%
  mutate(party = paste0(party,'.',year)) %>%
  select(-year) %>%
  spread(party,vote)

pres <- pres %>%
  mutate(partisan_lean = ((dem.2016 - rep.2016) - 0.021)*0.75 + ((dem.2012 - rep.2012) - 0.039)*0.25)


# benchmark in 2018 is partisan lean + 8.6 points for dems, so add that
pres <- pres %>%
  mutate(benchmark = partisan_lean + 0.086)


# join that with the 2018 results
results_benchmarked <-  results_2018 %>%
  left_join(pres,by='state')

# compute over/under-performance
results_benchmarked <- results_benchmarked %>%
  mutate(margin = dem-rep,
         performance = margin - benchmark) %>%
  arrange(desc(performance))


# look
View(results_benchmarked %>% select(state, office, partisan_lean, performance))

medians <- results_benchmarked %>%
  group_by(office) %>%
  summarise(performance = median(performance))


# a histogram
gg <- ggplot(results_benchmarked, aes(x=performance, col=office, fill=office)) +
  geom_vline(xintercept=0,linetype=2,col='gray40') +
  geom_density(alpha=0.7) +
  geom_vline(data=medians, aes(xintercept=performance,group=office, color=office)) +
  scale_color_pander() + scale_fill_pander() +
  labs(title="Statewide Democrats Underperfomed Expectations in 2018",
       subtitle="Across America, Democratic candidates — especially for governor — lagged behind\nstates' environment-adjusted partisan leans",
       x="Democratic Margin Relative to Benchmark\n(Partisan Lean + National Margin)",
       y="Density",
       caption="Sources: Secretaries of State") +
  scale_x_continuous(labels = function(x){x*100}) +
  guides('fill' = guide_legend(title="Office"), color = FALSE)


preview(gg, themearg = theme(legend.position = 'top'))


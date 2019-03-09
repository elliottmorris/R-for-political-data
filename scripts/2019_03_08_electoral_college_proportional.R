library(tidyverse)
library(politicaldata)

# get historical presidential election results
pres_history <- politicaldata::pres_results


# combine with the number of ec votesfor that state that year (here: https://raw.githubusercontent.com/brandly/presidential-election-data/master/json/<YEAR>.json)
library(jsonlite)

# a function for turning the json intot a data.frame
get_state_year_evs <- function(year){
  # if 2016, get the data for 2012 (it's the same, but not in the github file)
  year_str = ifelse(year==2016,2012,year)
  
  # grab the json
  results = fromJSON(url(sprintf('https://raw.githubusercontent.com/brandly/presidential-election-data/master/json/%s.json',year_str)))
  
  # get the votes data
  votes <- results$votes
  
  # for every state, return its name and number of total votes
  ec_data <- lapply(1:length(votes),
                    function(i){
                      state_abb <- names(votes)[i]
                      
                      state_data <- votes[[i]]
                      
                      ec <- state_data$electoral$republican + state_data$electoral$democrat
                      
                      return(data.frame(state_abb,ec,stringsAsFactors = F))
                    }
  ) %>% do.call('rbind',.)
  
  # return the data
  return(ec_data %>% mutate(year = year))
}

# get evs for each year in pres_history (exccept 2016)
votes_by_year <- lapply(unique(pres_history$year),
                        function(x){
                          return(get_state_year_evs(x))
                        }) %>%
  do.call('bind_rows',.)

# bind to the results data
pres_ev <- pres_history %>%
  left_join(votes_by_year %>% dplyr::rename(state=state_abb))


# now, for each year, calculate the winner-takes-all EC vote winner and the proportional EC vote winner
pres_ev <- pres_ev %>%
  mutate(other = ifelse(is.na(other),0,other)) %>% # first make sure the other = 0 is NA, else comparisons don't work
  mutate(dem_wta = case_when(dem > rep & dem > other ~ as.numeric(ec),
                             TRUE ~ 0 ),
         rep_wta = case_when(rep > dem & rep > other ~ as.numeric(ec),
                             TRUE ~ 0 ),
         other_wta = case_when(other > dem & other > rep ~ as.numeric(ec),
                               TRUE ~ 0),
         dem_prop = round(ec*(dem/(dem+rep))),
         rep_prop = round(ec*(rep/(dem+rep))))


# now total the Dem electoral votes by type by year
prop_v_wta <- pres_ev %>%
  group_by(year) %>% 
  summarise(dem_wta = sum(dem_wta),
            rep_wta = sum(rep_wta),
            dem_prop = sum(dem_prop),
            rep_prop = sum(rep_prop))

# graphing ------------
# graph the proportional allocation chart
ggplot(prop_v_wta, aes(x=year,y=dem_prop-270)) +
  geom_hline(yintercept = 0,linetype=2,col='gray60') +
  geom_bar(stat="identity",aes(col=dem_prop>=270,fill=dem_prop>=270)) +
  geom_label(aes(label=paste("D:",dem_prop),
                 y = ifelse(dem_prop>=270,
                            (dem_prop-270)+4,
                            (dem_prop-270)-4),
                 col=dem_prop>=270)) +
  scale_x_continuous(breaks=seq(1900,2016,4)) +
  scale_y_continuous(labels=function(x)return(x+270),
                     limits=c(-538+270,538-270),
                     breaks=c(0,135,270,404,538)-270) +
  scale_color_manual(values=c("TRUE"="#3498DB","FALSE"="#E74C3C")) + 
  scale_fill_manual(values=c("TRUE"="#3498DB","FALSE"="#E74C3C")) +
  labs(title="Electoral College Results Under Proportional Allocation*",
       subtitle="Under a system of proportional allocation, landslides don't happen because slim victories\nresult in nearly equal Electoral College vote allocation (and Hillary Clinton would have won in 2016)",
       x="Year",
       y="Democratic Electoral Votes",
       caption="*When discarding votes for third-party candidates")

# graph the WTA chart
ggplot(prop_v_wta, aes(x=year,y=dem_wta-270)) +
  geom_hline(yintercept = 0,linetype=2,col='gray60') +
  geom_bar(stat="identity",aes(col=dem_wta>=270,fill=dem_wta>=270)) +
  geom_label(aes(label=paste("D:",dem_wta),
                 y = ifelse(dem_wta>=270,
                            (dem_wta-270)+4,
                            (dem_wta-270)-4),
                 col=dem_wta>=270)) +
  scale_x_continuous(breaks=seq(1900,2016,4)) +
  scale_y_continuous(labels=function(x)return(x+270),
                     limits=c(-538+270,538-270),
                     breaks=c(0,135,270,404,538)-270) +
  scale_color_manual(values=c("TRUE"="#3498DB","FALSE"="#E74C3C")) + 
  scale_fill_manual(values=c("TRUE"="#3498DB","FALSE"="#E74C3C")) +
  labs(title="Electoral College Results Under Winner-Takes-All*",
       subtitle="Under the current rules, a candidate gets all of a state's Electoral College\nvotes so long as they have the largest statewide popular vote percentage (except in NE and ME).\nThis inflates wins/losses",
       x="Year",
       y="Democratic Electoral Votes",
       caption="*When ME and NE don't split votes by congressional district")


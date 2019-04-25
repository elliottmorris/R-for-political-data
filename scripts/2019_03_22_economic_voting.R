library(tidyverse)
library(survey)

# import data -------------------------------------------------------------
if(!exists("cces.raw")){
  cces.raw <- as_factor(read_dta('../../data_no_export/post/cces_2018/CCES2018_OUTPUT.dta'))
}


# mutate the vars we need
cces <- cces.raw %>%
  # mutate vars
  mutate(
    ### mutate demographic variables to match the census
    # race
    race = case_when(race=="White" ~ "White, Non-Hispanic",
                     race=="Black" ~ "Black, Non-Hispanic",
                     race=="Hispanic" ~ "Hispanic",
                     !race %in% c('skipped','not asked') ~ "Other, Non-Hispanic"),
    # sex
    sex = case_when(gender=="Male"~ "Male",
                    gender=="Female"~ "Female",
                    TRUE ~ NA_character_),
    # age
    AGE = year(Sys.Date()) - birthyr,
    age = case_when(AGE >= 18 & AGE <= 29 ~ "18-29",
                    AGE >= 30 & AGE <= 44 ~ "30-44",
                    AGE >= 45 & AGE <=  64 ~ "45-64",
                    AGE >= 65 ~ "65+",
                    TRUE ~ NA_character_),
    # education
    edu = case_when(educ == "No HS" ~ "No HS",
                    educ == "High school graduate" ~ "HS Graduate",
                    educ %in% c("Some college","2-year") ~ "Some college",
                    educ %in% c("4-year","Post-grad") ~ "College+",
                    TRUE ~ NA_character_),
    
    # change in household income
    change_hhinc = case_when(CC18_302 %in% c('not asked','skipped','Not sure') ~ NA_character_,
                             TRUE ~ as.character(CC18_302)),
    
    economy = case_when(CC18_301 %in% c("skipped","not asked","Not sure") ~ NA_character_,
                        TRUE ~ as.character(CC18_302)),
      
    ### pseudo-demographics for creating bonus census cells: pid and ideol
    # party
    party = case_when(grepl("Democrat",pid7) ~ "Dem/LeanDem",
                      grepl("Republican",pid7) ~ "Rep/LeanRep",
                      grepl("Independent",pid7) ~ "Ind",
                      TRUE ~ NA_character_),
    # ideology
    ideology = case_when(grepl("liberal",tolower(ideo5)) ~ "Liberal",
                         grepl("conservative",tolower(ideo5)) ~ "Conservative",
                         ideo5 == "Moderate" ~ "Moderate",
                         TRUE ~  NA_character_),
    
    ### attitudinal variables
    # opinion on health care
    aca_complete_repeal = case_when(CC18_327c == 'Support' ~ 1,
                                    CC18_327c == 'Oppose' ~ 0,
                                    CC18_327c == 'skipped' ~ NA_real_,
                                    CC18_327c == 'not asked' ~ NA_real_),
    
    ### voting variables
    # vote in 2016
    vote_2016 = case_when(CC18_317 %in% c('I did not cast a vote for president',
                                          "I don't recall","skipped","not asked") ~ NA_character_,
                          CC18_317=="Someone else" ~ "Other",
                          TRUE ~ as.character(CC18_317)),
    
    vote_clinton = ifelse(vote_2016 == 'Hillary Clinton',1,0),
    vote_trump = ifelse(vote_2016 == 'Donald Trump',1,0),
    
    # vote in 2018
    vote_2018 = case_when(grepl('HouseCand1Party',CC18_412) ~ as.character(HouseCand1Party),
                          grepl('HouseCand2Party',CC18_412) ~ as.character(HouseCand2Party),
                          TRUE ~ NA_character_),
    
    trump_defect = case_when(vote_2016 == "Donald Trump" & vote_2018 == "Democratic" ~ 1,
                             TRUE ~ 0),
    
    # vote in 2012
    
    
    ### MISC
    # weight
    weight = as.numeric(commonpostweight),
    
    state_name = as.factor(inputstate),
    
    
    ### CONVERSIONS
    vote_2018 = as.factor(vote_2018)
  ) %>%
  dplyr::select(state_name,
                race, sex, age, edu, party, ideology,
                change_hhinc, economy, aca_complete_repeal,
                vote_trump, vote_2016, vote_2018, trump_defect,
                weight) %>%
  filter(!is.na(weight)) %>% filter (!is.na(weight))



# Make survey object ------------------------------------------------------
cces.svy <- svydesign(~1,data=cces,weights = ~weight)



# Trump defection vs economic anziety -------------------------------------
fit <- svyglm(trump_defect ~ race + sex + age + edu + party + ideology + change_hhinc + aca_complete_repeal, # economy
       subset(cces.svy,vote_trump==1)) 

#summary(fit)

#logit2prob(coef(fit))

# coef plot
coef_plot <- ggplot(broom::tidy(fit)) +
  geom_vline(xintercept=0,linetype=2,col='red') +
  geom_point(aes(x=estimate,y=term)) +
  geom_segment(aes(x=estimate-std.error*1.96,
                   xend=estimate+std.error*1.96,
                   y=term,yend=term),
               size=0.4) +
  geom_segment(aes(x=estimate-std.error*1.282,
                   xend=estimate+std.error*1.282,
                   y=term,yend=term),
               size=0.4) +
  labs(title="...So What Did? A Preliminary Model.",
       x="Effect",
       y="Term",
       caption="Source: 2018 Cooperative Congressional Election Study")


# predict
pred_df <- data.frame(race="White, Non-Hispanic",
                      sex="Male",
                      age="45-64",
                      edu="HS Graduate",
                      party="Rep/LeanRep",
                      ideology="Conservative",
                      aca_complete_repeal = 1)

pred_df <- pred_df %>% 
  slice(rep(1:n(), each = 5)) %>%
  mutate(economy = c("Decreased a lot","Decreased somewhat","Stayed about the same","Increased somewhat","Increased a lot"),
         economy = factor(economy, levels=c("Decreased a lot","Decreased somewhat","Stayed about the same","Increased somewhat","Increased a lot")),change_hhinc = c("Increased a lot","Increased somewhat", "Stayed about the same","Decreased somewhat","Decreased a lot"),
         
         change_hhinc = c("Increased a lot","Increased somewhat", "Stayed about the same","Decreased somewhat","Decreased a lot"),
         change_hhinc = factor(change_hhinc,
                               levels=rev(c("Increased a lot","Increased somewhat", "Stayed about the same","Decreased somewhat","Decreased a lot"))))


pred_df <- pred_df %>% 
  cbind(predict(fit,
                newdata = pred_df,
                type='response')
  )

# plot predictions
gg <- ggplot(pred_df,aes(x=change_hhinc,y=response)) + 
  geom_point() +
  geom_segment(aes(xend=change_hhinc,
                   y=response - SE*1.96,
                   yend=response + SE*1.96),
               size=0.4) +
  geom_segment(aes(xend=change_hhinc,
                   y=response - SE*1.282,
                   yend=response + SE*1.282),
               size=0.8) +
  labs(title="Changes in Personal Income Didn't Cause Defection From Trump in 2018",
       subtitle="Predicted probability that a conservative, non-college educated white male Republican age 45-64 would switch\nfrom voting for Trump in 2016 to a House Democrat in 2018",
       x="Change in Household Income Over Last Year",
       y="Probability of Voting for a Democratic House Candidate in 2018",
       caption="Source: 2018 Cooperative Congressional Election Study")  +
  coord_flip()

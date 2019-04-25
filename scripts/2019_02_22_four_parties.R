source("~/setup_elliott.R")

# Step 1: Import survey data -------------
# https://www.voterstudygroup.org/publications/2018-voter-survey/2018-voter-survey-top-lines)
vsg <- read.csv("VSG_DATA",stringsAsFactors = F)

# we only want panelists
vsg <- vsg[!is.na(vsg$weight_panel),]

# and remove duplicate cases
vsg <- vsg[!duplicated(vsg$case_identifier),]


# Step 2: Choose policies and recode as 1: liberal 0: conservative -----------
# Policies chosen are same as Drutman's: https://www.voterstudygroup.org/publications/2016-elections/political-divisions-in-2016-and-beyond
vsg.coded <- vsg %>%
  mutate(
    # The View That Politics is a Rigged Game
    # Elections today don’t matter; things stay the same no matter who we vote in.
    RIGGED_SYSTEM_1_2016 = case_when(RIGGED_SYSTEM_1_2016 %in% c("Agree","Strongly agree") ~ 0,
                                     RIGGED_SYSTEM_1_2016 %in% c("Disagree","Strongly disagree") ~ 1,
                                     TRUE ~ NA_real_),
    # People like me don’t have any say in what the government does.
    RIGGED_SYSTEM_5_2016 = case_when(RIGGED_SYSTEM_5_2016 %in% c("Agree","Strongly agree") ~ 0,
                                     RIGGED_SYSTEM_5_2016 %in% c("Disagree","Strongly disagree") ~ 1,
                                     TRUE ~ NA_real_),
    # Elites in this country don’t understand the problems I am facing.
    RIGGED_SYSTEM_6_2016 = case_when(RIGGED_SYSTEM_6_2016 %in% c("Agree","Strongly agree") ~ 0,
                                     RIGGED_SYSTEM_6_2016 %in% c("Disagree","Strongly disagree") ~ 1,
                                     TRUE ~ NA_real_),
    
    
    # The Importance of Social Security/Medicare
    # How important is Social Security to the respondent?
    imiss_m_2017 = case_when(imiss_m_2017 %in% c("Very Important","Somewhat Important") ~ 1,
                             imiss_m_2017 %in% c("Not very Important","Unimportant") ~ 0,
                             TRUE ~ NA_real_),
    # How important is Medicare to the respondent?
    imiss_s_2017 = case_when(imiss_s_2017 %in% c("Very Important","Somewhat Important") ~ 1,
                             imiss_s_2017 %in% c("Not very Important","Unimportant") ~ 0,
                             TRUE ~ NA_real_),
    
    
    # Attitudes on Foreign Trade A battery of questions on the costs/benefits of free trade.
    free_trade_1_2016 = case_when(free_trade_1_2016 == "Increase" ~ 1,
                                  free_trade_1_2016 == "Decrease" ~ 0,
                                  TRUE ~ NA_real_),
    free_trade_2_2016 = case_when(free_trade_2_2016 == "Increase" ~ 1,
                                  free_trade_2_2016 == "Decrease" ~ 0,
                                  TRUE ~ NA_real_),
    free_trade_3_2016 = case_when(free_trade_3_2016 == "Increase" ~ 1,
                                  free_trade_3_2016 == "Decrease" ~ 0,
                                  TRUE ~ NA_real_),
    free_trade_4_2016 = case_when(free_trade_4_2016 == "Increase" ~ 1,
                                  free_trade_4_2016 == "Decrease" ~ 0,
                                  TRUE ~ NA_real_),
    free_trade_5_2016 = case_when(free_trade_5_2016 == "Increase" ~ 1,
                                  free_trade_5_2016 == "Decrease" ~ 0,
                                  TRUE ~ NA_real_),
    
    
    # Attitudes On Gender Roles A battery of questions on the role of women in society.
    sexism1 = case_when(sexism1 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                        sexism1 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                        TRUE ~ NA_real_),
    sexism2 = case_when(sexism2 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                        sexism2 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                        TRUE ~ NA_real_),
    sexism3 = case_when(sexism3 %in% c("Strongly Agree","Somewhat Agree") ~ 1,
                        sexism3 %in% c("Somewhat Disagree","Strongly Disagree") ~ 0,
                        TRUE ~ NA_real_),
    sexism4 = case_when(sexism4 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                        sexism4 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                        TRUE ~ NA_real_),
    sexism5 = case_when(sexism5 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                        sexism5 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                        TRUE ~ NA_real_),
    sexism6 = case_when(sexism6 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                        sexism6 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                        TRUE ~ NA_real_),
    
    
    # Pride in America
    # How proud are you of America’s history?
    proudhis_2016 = case_when(proudhis_2016 %in% c("Very proud","Somewhat proud") ~ 0,
                              proudhis_2016 %in% c("Not very proud","Not proud at all") ~ 1,
                              TRUE ~ NA_real_),
    # I would rather be a citizen of America than any other country in the world.
    amcitizen_2016 = case_when(amcitizen_2016 %in% c("Agree","Agree strongly") ~ 0,
                               amcitizen_2016 %in% c("Disagree","Disagree strongly") ~ 1,
                               TRUE ~ NA_real_),
    
    
    # The Perception That “People Like Me” Are Losing Ground
    # Life in America today for people like me is worse compared to 50 years ago.
    Americatrend_2017 = case_when(Americatrend_2017 %in% c("Better","About the same") ~ 1,
                                  Americatrend_2017 %in% c("Worse") ~ 0,
                                  TRUE ~ NA_real_),
    # In America, the values and culture of people like me are becoming rarer and less accepted.
    values_culture_2017 = case_when(values_culture_2017 %in% c("Generally becoming more widespread and accepted","Holding steady") ~ 1,
                                    values_culture_2017 %in% c("Generally becoming rarer and less accepted") ~ 0,
                                    TRUE ~ NA_real_),
    
    
    # Attitudes Toward African-Americans A battery of racial resentment questions toward African-Americans.
    race_deservemore_2016 = case_when(race_deservemore_2016 %in% c("Strongly Agree","Somewhat Agree") ~ 1,
                                      race_deservemore_2016 %in% c("Somewhat Disagree","Strongly Disagree") ~ 0,
                                      TRUE ~ NA_real_),
    race_overcome_2016 = case_when(race_overcome_2016 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                                   race_overcome_2016 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                                   TRUE ~ NA_real_),
    race_tryharder_2016 = case_when(race_tryharder_2016 %in% c("Strongly Agree","Somewhat Agree") ~ 0,
                                    race_tryharder_2016 %in% c("Somewhat Disagree","Strongly Disagree") ~ 1,
                                    TRUE ~ NA_real_),
    race_slave_2016 = case_when(race_slave_2016 %in% c("Strongly Agree","Somewhat Agree") ~ 1,
                                race_slave_2016 %in% c("Somewhat Disagree","Strongly Disagree") ~ 0,
                                TRUE ~ NA_real_),
    
    
    # Feelings Toward Muslims
    # Favoring or opposing temporarily banning Muslims from other countries from entering the U.S.
    immi_muslim = case_when(immi_muslim %in% c("Strongly favor","Somewhat favor") ~ 0,
                            immi_muslim %in% c("Strongly oppose","Somewhat oppose") ~ 1,
                            TRUE ~ NA_real_),
    # Feeling thermometer rating toward Muslims.
    ft_muslim_2017 = case_when(as.numeric(ft_muslim_2017) > 50 ~ 1,
                               as.numeric(ft_muslim_2017) < 50 ~ 0,
                               TRUE ~ NA_real_),
    
    
    # Attitudes on Immigration
    # Whether illegal immigrants contribute to American society/are a drain.
    immi_contribution = case_when(immi_contribution == "Mostly make a contribution" ~ 1,
                                  immi_contribution == "Mostly a drain" ~ 0,
                                  TRUE ~ NA_real_),
    # Favoring or opposing a legal way for illegal immigrants already in the United States to become U.S. citizens.
    immi_naturalize = case_when(immi_naturalize == "Favor" ~ 1,
                                immi_naturalize == "Oppose" ~ 0,
                                TRUE ~ NA_real_),
    # Whether it should be easier/harder for foreigners to immigrate to the U.S. legally than it is currently.
    immi_makedifficult = case_when(immi_makedifficult %in% c("Much easier","Slightly easier") ~ 1,
                                   immi_makedifficult %in% c("Slightly harder","Much harder") ~ 0,
                                   TRUE ~ NA_real_),
    
    
    
    # Attitudes on Moral Issues
    # View on abortion.
    abortview3_2016 = case_when(abortview3_2016 %in% c("Legal in all cases","Legal/Illegal in some cases") ~ 1,
                                abortview3_2016 %in% c("Illegal in all cases") ~ 0,
                                TRUE ~ NA_real_),
    # View on gay marriage.
    gaymar_2016 = case_when(gaymar_2016 == "Favor" ~ 1,
                            gaymar_2016 == "Oppose" ~ 0,
                            TRUE ~ NA_real_),
    # View on transgender bathrooms.
    view_transgender_2016 = case_when(view_transgender_2016 == "Should be allow to us the restrooms of the gender with which they currently identify" ~ 1,
                                      view_transgender_2016 == "Should be required to use the restrooms of the gender they were born into" ~ 0,
                                      TRUE ~ NA_real_),
    
    
    # Attitudes on Economic Inequality
    # Whether our economic system is biased in favor of the wealthiest Americans.
    RIGGED_SYSTEM_3_2016 = case_when(RIGGED_SYSTEM_3_2016 %in% c("Strongly agree","Agree") ~ 1,
                                     RIGGED_SYSTEM_3_2016 %in% c("Disagree","Strongly disagree") ~ 0,
                                     TRUE ~ NA_real_),
    # Whether we should raise taxes on the wealthy.
    taxdoug = case_when(taxdoug == "Yes" ~ 1,
                        taxdoug == "No" ~ 0,
                        TRUE ~ NA_real_),
    # Whether distribution of money and wealth in this country is fair.
    wealth_2016 = case_when(wealth_2016 == "Distribution is fair" ~ 0,
                            wealth_2016 == "Should be more evenly distributed" ~ 1,
                            TRUE ~ NA_real_),
    
    
    # Attitudes Toward Government Intervention
    # Whether we need a strong government to handle complex economic problems.
    gvmt_involment_2016 = case_when(gvmt_involment_2016 == "We need a strong government to handle today's complex economic problems" ~ 1,
                                    gvmt_involment_2016 == "People would be better able to handle today's problems within a free market with less government involvement" ~ 0,
                                    TRUE ~ NA_real_),
    # Whether there is too much/too little regulation of business by the government.
    govt_reg_2017 = case_when(govt_reg_2017 %in% c("Too little","About the right amount") ~ 1,
                              govt_reg_2017 %in% c("Too much") ~ 0,TRUE ~ NA_real_)
  ) %>% 
  select(RIGGED_SYSTEM_1_2016, RIGGED_SYSTEM_5_2016, RIGGED_SYSTEM_6_2016, imiss_m_2017, imiss_s_2017, free_trade_1_2016, free_trade_2_2016, free_trade_3_2016, free_trade_4_2016, free_trade_5_2016, sexism1, sexism2, sexism3, sexism4, sexism5, sexism6, proudhis_2016, amcitizen_2016, Americatrend_2017, values_culture_2017, race_deservemore_2016, race_overcome_2016, race_tryharder_2016, race_slave_2016, immi_muslim, ft_muslim_2017, immi_contribution, immi_naturalize, immi_makedifficult, abortview3_2016, gaymar_2016, view_transgender_2016, RIGGED_SYSTEM_3_2016, taxdoug, wealth_2016, gvmt_involment_2016, govt_reg_2017,case_identifier)


# only keep observations with below avg num missing
num_missing <- apply(vsg.coded,MARGIN = 1,FUN = function(x){length(x[is.na(x)])})

vsg.coded <- vsg.coded[num_missing < mean(num_missing),]

# save case ids: later we'll want to get some contextual variable
row.names(vsg.coded) <- vsg.coded$case_identifier

ids <- vsg.coded$case_identifier

vsg.coded$case_identifier <- NULL

# Step 3: Impute responses -------------
library(mice)

imputed <-mice(vsg.coded, method='pmm',m = 1,maxit = 5,printFlag = FALSE)

vsg.coded <- complete(imputed)

# Step 4: Compute euclidian distances from most conservative position ---------
# distance measures
euc.dist <- function(x1, x2){
  sqrt(sum((x1 - x2) ^ 2))
}

jaccard.dist <- function(x1, x2){
  a <- sum(x1==x2) * 2 
  b <- length(x1) + length(x2)
  c <- a/b
  d <- c * 100
  
  return(d)
}

#jaccard.dist(c(0,0,0,0,0),c(1,1,0,0,1))
#euc.dist(c(0,0,0,0,0),c(1,1,0,0,1))

# find the most conservative voter among dims 1 & 2
most_conservative_votes = 
  data.frame(vote = rep(0,37),
             dim = c(1,1,1,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1))


euc_distances <- 
  lapply(1:nrow(vsg.coded),
         function(x){
           # get their votes
           person <- as.numeric(vsg.coded[x,])
           
           # break down into dimensions
           economic <- person[which(most_conservative_votes$dim==1)]
           social <- person[which(most_conservative_votes$dim==2)]
           
           # get most cons economic & social positions
           economic_cons <- most_conservative_votes$vote[which(most_conservative_votes$dim==1)]
           social_cons <- most_conservative_votes$vote[which(most_conservative_votes$dim==2)]
           
           # get two distances
           dim_1 <- jaccard.dist(economic[!is.na(economic)],
                                 economic_cons[!is.na(economic)])
           
           dim_2 <- jaccard.dist(social[!is.na(social)],
                                 social_cons[!is.na(social)])
           
           # adjust the euclidian distance because it exaggerates spread -- take the sq root
           
           
           # just get the mean -- euc distances aren't normally distributed and look wonky
           #dim_1 <- mean(economic,na.rm=T)
           #dim_2 <- mean(social,na.rm=T)
           
           return(data.frame(dim_1,dim_2))
           
         }) %>% do.call('rbind',.)


# Step 5: Add contextual variables -------------
# join back up with the vsg. data. We want 2016 pres votes 
euc_distances$case_identifier <- ids

# join up with original vsg, so we can get pres vote
vsg.ideo <- vsg %>% 
  left_join(euc_distances, by='case_identifier') %>%
  filter(!is.na(dim_1))

# recode pres vote, trump approval
vsg.ideo <- vsg.ideo %>%
  mutate(vote_2016 = case_when(presvote16post_2016 == "Donald Trump" ~ "Trump",
                               presvote16post_2016 == "Hillary Clinton" ~ "Clinton",
                               presvote16post_2016 %in% c("Gary Johnson","Jill Stein","Evan McMullin","Other") ~ "Other",
                               TRUE ~ NA_character_),
         
         trump_approve_2 = case_when(trumpapp_2017 %in% c("Strongly Approve","Somewhat Approve") ~ "Approve",
                                     trumpapp_2017 %in% c("Somewhat Disapprove","Strongly Disapprove") ~ "Disapprove",
                                     TRUE ~ NA_character_),
         
         trump_approve_4 = case_when(trumpapp_2017=="Don't know" ~ NA_character_,
                                     grepl("pprove",trumpapp_2017) ~ trumpapp_2017,
                                     TRUE ~ NA_character_),
         trump_approve_4 = factor(trump_approve_4,
                                  levels=c("Strongly Approve","Somewhat Approve","Somewhat Disapprove","Strongly Disapprove")),
         
         dem_primary_2016 = case_when(pp_demprim16_2016 == "Hillary Clinton" ~ "Clinton",
                                      pp_demprim16_2016 == "Bernie Sanders" ~ "Sanders",
                                      pp_demprim16_2016 == "Someone else" ~ "Other",
                                      TRUE ~ NA_character_),
         
         rep_primary_2016 = case_when(pp_repprim16_2016 == "Donald Trump" ~ "Trump",
                                      grepl("Kasich|Rubio|Cruz|else|recall",pp_repprim16_2016) ~ "Other",
                                      TRUE ~ NA_character_),
         
         # self-assigned party
         pid_lean = case_when(grepl('Democrat',pid7)~'Dem/Lean Dem',
                              grepl('Republican',pid7)~'Rep/Lean Rep',
                              pid7=="Independent" ~ "Pure Ind"),
         
         pid_lean = factor(pid_lean,levels=c("Dem/Lean Dem","Rep/Lean Rep","Pure Ind")),
         
         # represented by own party
         coparty_repn = case_when(pid_lean=="Dem/Lean Dem" & 
                                    grepl('well-represented',represent_dem) ~ "Well-represented",
                                  pid_lean=="Rep/Lean Rep" & 
                                    grepl('well-represented',represent_rep) ~ "Well-represented",
                                  pid_lean=="Dem/Lean Dem" & 
                                    grepl('poor',represent_dem) ~ "Poorly represented",
                                  pid_lean=="Rep/Lean Rep" & 
                                    grepl('poor',represent_rep) ~ "Poorly represented",
                                  TRUE ~ NA_character_),
         
         coparty_repn = factor(coparty_repn,levels=c("Well-represented","Poorly represented"))
         
  )

# reclase dim from 0 = cons 1 = dem to -1 dem 1 cons
vsg.ideo$dim_1.rescale <- rescale(vsg.ideo$dim_1,c(-1,1),c(min(euc_distances$dim_1),max(euc_distances$dim_1)))
vsg.ideo$dim_2.rescale <- rescale(vsg.ideo$dim_2,c(-1,1),c(min(euc_distances$dim_2),max(euc_distances$dim_2)))

# Step 6: Crosstabs  ---------
vsg.svy <- svydesign(~1,data = vsg.ideo,weights = ~weight_panel)

#svymean(~coparty_repn,vsg.svy,na.rm=T)
#svyby(~coparty_repn,~pid_lean,vsg.svy,svymean,na.rm=T)

# Step 7: Plots ---------
# trump approval
gg <- ggplot(vsg.ideo %>% filter(!is.na(coparty_repn)), 
             aes(x=dim_1.rescale, y=dim_2.rescale, col=coparty_repn)) +
  geom_vline(xintercept = 0,linetype=2) + 
  geom_hline(yintercept = 0,linetype=2) +
  geom_jitter(size=2,alpha=0.5) +
  labs(title="Most Democrats and Republicans Feel Represented",
       subtitle="73% of Americans report feeling well-represented by their party",
       x="Economic Dimension\n(-1=Liberal, 1=Conservative)",
       y="Social/Lifestyle/Elites Dimension\n(-1=Liberal, 1=Conservative)",
       caption="Source: 2018 VOTER Survey") +
  scale_color_manual("Feel represented by party?", values=c("Well-represented" ="#2ECC71",
                                                            "Poorly represented" = "#DC7633")) +
  coord_cartesian(xlim=c(-1,1),ylim=c(-1,1)) 

preview(gg, themearg = theme(legend.position = 'bottom')) ## my theme alternative to `print(gg)`

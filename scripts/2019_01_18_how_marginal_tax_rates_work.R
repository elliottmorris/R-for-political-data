rm(list=ls())
source("~/setup_elliott.R")

# define tax brackets
current_brackets <- data.frame(dollars = c(9525,38700,82500,157500,200000,500000,Inf),
                               tax_rate = c(10,12,22,24,32,35,37)/100)

high_brackets <- data.frame(dollars = c(500,1000,1500,2000,4000,6000,8000,10000,12000,14000,16000,18000,20000,22000,26000,32000,38000,44000,50000,60000,70000,80000,90000,100000,Inf)*5.496,
                            tax_rate = c(14,15,16,17,19,22,25,28,32,36,39,42,45,48,50,53,55,58,60,62,64,66,68,69,70)/100)


# define a function for paying your taxes
pay_taxes <- function(income,brackets){
  # for each bracket, subtract x dollars from income
  taxes_total <- 0
  #income <- 5000
  income_left <- income
  
  for(i in 1:nrow(brackets)){
    # get taxed dollars and tax rate
    dollars_taxed <- brackets[i,]$dollars - 
      ifelse(i==1,0,brackets[i-1,]$dollars)
    
    rate_of_tax <- brackets[i,]$tax_rate
    
    # if you're at the top marginal, reset the Inf to = remaining income
    if(dollars_taxed == Inf){dollars_taxed <- income_left}
    
    # if residual income <0, set taxed dollars = remaining income
    if(income_left - dollars_taxed < 0){dollars_taxed <- income_left}
    
    # calculate taxes paid
    taxes_paid <- dollars_taxed * rate_of_tax
    
    # calculate residual income
    income_left <- income_left - dollars_taxed
    
    taxes_total <- taxes_total + taxes_paid
    
    # if residual income <0, recalc taxes paid and return
    if(income_left == 0){break} 
  }
  
  return(data.frame(income,taxes_total,on_paper=rate_of_tax))
}


# actual vs perception ----------------------------------------------------


# calc taxes at different incomes
tax_df <- 
  pblapply(seq(1,6e05,1000),
       function(x){
         data.frame(type=c('current','high')) %>%
           cbind(
             rbind(pay_taxes(x,current_brackets))
           )
         
         }) %>%
  do.call('rbind',.)

tax_df <- tax_df %>%
  mutate(tax_rate = taxes_total/income)

# marginal vs perception
ggplot(tax_df,aes(x=income,y=taxes_total)) +
  geom_vline(data=data.frame(x=current_brackets$dollars[1:6]),
             aes(xintercept=x),col='gray40',linetype=2) +
  geom_line()  +
  geom_line(aes(x=income,y=on_paper*income),col='red') +
  scale_x_continuous(breaks=c(current_brackets$dollars[1:6]),
                     labels=function(x){paste0("$",round(x/1000),"k")}) +
  scale_y_continuous(labels=function(x){paste0("$",round(x/1000),"k")}) +
  theme_minimal() +
  labs(title="Tax rates aren't simply income times rate",
       subtitle="Tax rates are marginal, which means you only pay the higher rate on income above each bracket.\nFor most Americans, this decreases their total tax burden.",
       x="Income",
       y="Taxes paid",
       caption='Source: IRS') +
  ggplot2::annotate('text',x=300000,y=115000,label='Not how taxes work',angle=30,col='red') +
  ggplot2::annotate('text',x=320000,y=80000,label='Actually how taxes work',angle=30,col='black')

# rate
ggplot(tax_df,aes(x=income,y=tax_rate)) +
  geom_vline(data=data.frame(x=current_brackets$dollars[1:6]),
             aes(xintercept=x),col='gray40',linetype=2) +
  geom_line()  +
  geom_line(aes(x=income,y=on_paper),col='red') +
  scale_x_continuous(breaks=c(current_brackets$dollars[1:6]),
                     labels=function(x){paste0("$",round(x/1000),"k")}) +
  scale_y_continuous(labels=function(x){paste0(round(x*100,1),"%")},
                     limits=c(0,0.40)) +
  theme_minimal() +
  labs(title="Tax rates aren't simply income times rate",
       subtitle="Tax rates are marginal, which means you only pay the higher rate on income above each bracket.\nFor most Americans, this decreases their total tax burden.",
       x="Income",
       y="Tax rate",
       caption='Source: IRS') +
  ggplot2::annotate('text',x=300000,y=0.33,label='Not how taxes work',col='red') +
  ggplot2::annotate('text',x=320000,y=0.25,label='Actually how taxes work',angle=10,col='black')


# 2018 vs 1970 ---------
# calc
tax_df.comp <- 
  pblapply(seq(1,6e05,1000),
           function(x){
             data.frame(type=c('2018','1970')) %>%
               cbind(
                 rbind(pay_taxes(x,current_brackets)) %>%
                   rbind(pay_taxes(x,high_brackets))
               )
             
           }) %>%
  do.call('rbind',.)

tax_df.comp <- tax_df.comp %>%
  mutate(tax_rate = taxes_total/income)

# plot income
ggplot(tax_df.comp,aes(x=income,y=taxes_total,col=type)) +
  geom_vline(data=data.frame(x=current_brackets$dollars[1:6]),
             aes(xintercept=x),col='gray40',linetype=2) +
  geom_line()  +
  scale_x_continuous(breaks=c(current_brackets$dollars[1:6]),
                     labels=function(x){paste0("$",round(x/1000),"k")}) +
  scale_y_continuous(labels=function(x){paste0("$",round(x/1000),"k")}) +
  theme_minimal() +
  labs(title="What would a return to a 1970s tax rate look like?",
       subtitle="The wealthy used to pay a much bigger slice of the federal income pie",
       x="Income",
       y="Taxes paid",
       caption='Source: IRS') +
  scale_color_manual("Tax code",values=c('1970'='#E74C3C','2018'='#F39C12'))


# plot rate
ggplot(tax_df.comp,aes(x=income,y=tax_rate,col=type)) +
  geom_vline(data=data.frame(x=current_brackets$dollars[1:6]),
             aes(xintercept=x),col='gray40',linetype=2) +
  geom_line()  +
  scale_x_continuous(breaks=c(current_brackets$dollars[1:6]),
                     labels=function(x){paste0("$",round(x/1000),"k")}) +
  scale_y_continuous(labels=function(x){paste0(round(x*100,1),"%")}) +
  theme_minimal() +
  labs(title="What would a return to a 1970s tax rate look like?",
       subtitle="The wealthy used to pay a much bigger slice of the federal income pie...",
       x="Income",
       y="Tax rate",
       caption='Source: IRS') +
  scale_color_manual("Tax code",values=c('1970'='#E74C3C','2018'='#F39C12'))


tax_df.comp2 <- 
  pblapply(seq(1,2e06,10000),
           function(x){
             data.frame(type=c('2018','1970')) %>%
               cbind(
                 rbind(pay_taxes(x,current_brackets)) %>%
                   rbind(pay_taxes(x,high_brackets))
               )
             
           }) %>%
  do.call('rbind',.)

tax_df.comp2 <- tax_df.comp2 %>%
  mutate(tax_rate = taxes_total/income)

# plot
ggplot(tax_df.comp2,aes(x=income,y=taxes_total/income,col=type)) +
  geom_vline(data=data.frame(x=current_brackets$dollars[1:6]),
             aes(xintercept=x),col='gray40',linetype=2) +
  geom_line()  +
  scale_x_continuous(labels=function(x){ifelse(x<1e06,paste0("$",round(x/1000),"k"),paste0("$",round(x/1000000),"m"))}) +
  scale_y_continuous(labels=function(x){paste0(round(x*100,1),"%")}) +
  theme_minimal() +
  labs(title="What would a return to a 1970s tax rate look like?",
       subtitle="The wealthy used to pay a much bigger slice of the federal income pie...\n...especially the super-wealthy",
       x="Income",
       y="Tax rate",
       caption='Source: IRS') +
  scale_color_manual("Tax code",values=c('1970'='#E74C3C','2018'='#F39C12'))
  
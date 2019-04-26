# R for Political Data Science


A repository to provide a central location for the files and data used in my [weekly posts](https://www.thecrosstab.com/project/r-for-political-data-science-weekly/) on analyzing political data in R. Inspired by the folks participating in [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday), I'm really intending this to be an introduction to techniques of data science that have real world applied use cases. Again, read more [on my blog](https://www.thecrosstab.com/project/r-for-political-data-science-weekly/). 

### My DataCamp Course and R Package

If you're looking for a more guided introduction to the topic, consider taking my course ["Analyzing Polling and Election Data in R" at DataCamp.com](https://www.datacamp.com/courses/analyzing-election-and-polling-data-in-r). And, of course, check out my R package [`politicaldata`](https://github.com/elliottmorris/politicaldata) that makes downloading and analyzing a lot of these data even easier.


### A Guide to Analyzing Political Data in R

I am preparing [a guide](https://www.thecrosstab.com/project/r-politics-guide/) on how to analyze and visualize political data in R, which compiles much of the work here into a longer, more cohesive format. It is not quite long enough to be a book, but will (in the end) be fairly comprehensive. The materials for this text can be found in the `/guide/` subdirectory.


### Housekeeping

An overview of this repository's files for the weekly posts detailed below:


- The `/data/` subdirectory is a list of all the data used in each post, cleaned up and ready to be imported.
- The `/scripts/` subdirectory contains scripts that analyze the datasets. These scripts are made of all the same code included in the posts, but the commentary is stripped away.

If your code doesn't work, make sure you've removed references to my personal R theme, `theme_elliott()`, which I suggest replacing with `theme_minimal()`. If you're still having trouble, open an issue with a reproducible example (which you can generate easily in R using [`reprex`](https://github.com/tidyverse/reprex)).


# Data and posts 

Here is a table of all the posts, data, and scripts in chronological order:

| Date |  Data | Script | Post 
| - | - | - | -
| 2019-01-04 | [🔗](https://voteview.com/static/data/out/members/Hall_members.csv) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_04_polarization_in_congress.R) | [Polarization in the 115h Congress](https://www.thecrosstab.com/2019/01/04/how-much-has-congress-polarized/) 
| 2019-01-11 | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_01_11_cnn_poll.csv) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_11_cnn_poll.R) | [This Early Before 2020, It’s All About Name Recognition](https://www.thecrosstab.com/2019/01/11/2020-cnn-poll-favs/)
| 2019-01-18 | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_18_how_marginal_tax_rates_work.R) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_18_how_marginal_tax_rates_work.R) | [How Marginal Tax Rates Work](https://www.thecrosstab.com/2019/01/18/how-tax-rates-work-1970s/)
| 2019-01-25 | [🔗](https://voteview.com/static/data/out/members/Hall_members.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_01_25_counterintuitive_no_votes.R) | [What Happens To Our Algorithms When Socialists Vote in Congress](https://www.thecrosstab.com/2019/01/25/counterintuitive-no-votes/)
| 2019-02-01 | [🔗](https://www.voterstudygroup.org/data) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_01_distribution_of_voters.R) | [The Ideological Diversity of the American Electorate](https://www.thecrosstab.com/2019/02/01/distribution-of-voters/)
| 2019-02-08 | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_02_08_how_liberal_2020_dems.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_08_how_liberal_2020_dems.R) | [Just How Liberal Are the 2020 Democratic Candidates?](https://www.thecrosstab.com/2019/02/08/how-liberal-2020-dems/)
| 2019-02-15 | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_02_15_2020_twitter_primary.Rdata) | [🔗](hDtps://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_15_2020_twitter_primary.R) | [The 2020 Twitter Primary](https://www.thecrosstab.com/2019/02/15/2020-twitter-primary/)
| 2019-02-22  | [🔗](https://www.voterstudygroup.org/data) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_22_four_parties.R) | [Four Parties in America? Probably Not Anytime Soon](https://www.thecrosstab.com/2019/02/22/four-parties/)
| 2019-03-01 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/data/2019_03_01_2018_vs_partisanship.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_01_2018_vs_partisanship.R) | [The "Strongest" Democrats and Republicans (That Ran for Office in 2018)](https://www.thecrosstab.com/2019/03/01/2018-vs-partisanship/)
| 2019-03-08 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_08_electoral_college_proportional.R) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_08_electoral_college_proportional.R) | [What If Each State Allocated Their Electoral College Votes Proportionally?](https://www.thecrosstab.com/2019/03/08/electoral-college-proportional/)
| 2019-03-15 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/data/2019_03_15_beto_media_data.RData) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_15_media_beto.R) | [Beto O’Rourke is a Media Sweetheart](https://www.thecrosstab.com/2019/03/15/media-beto/)
| 2019-03-22 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_22_economic_voting.R) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_22_economic_voting.R) | [Do Voters Still Care About The Economy?](https://www.thecrosstab.com/2019/03/22/economic-voting/)
| 2019-03-29 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/data/2019_03_29_2020_media_gender_bias.RData) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_03_29_gender_media_bias.R) | [Is Media Coverage of the 2020 Democratic Primary Biased by Gender?]()
| 2019-04-05 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/data/2019_04_05_how_young_2020_democrats.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_04_05_how_young_2020_democrats.R) | [How Old/Young Are The 2020 Democratic Candidates?]()
| 2019-04-11 |[🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/data/2019_04_11_mayor_pete_hype.csv) | [🔗](2ttps://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_04_11_mayor_pete_hype.R) | [The Mayor Pete Hype is Real]()

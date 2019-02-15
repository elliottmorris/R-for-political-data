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

| Date | Post link | Data | Script | Title 
| - | - | - | - | -
| 2019-01-04 | [🔗](https://www.thecrosstab.com/2019/01/04/how-much-has-congress-polarized/) | [🔗](https://voteview.com/static/data/out/members/Hall_members.csv) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_04_polarization_in_congress.R) | Polarization in the 115h Congress
| 2019-01-11 | [🔗](https://www.thecrosstab.com/2019/01/11/2020-cnn-poll-favs/) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_01_11_cnn_poll.csv) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_11_cnn_poll.R) | This Early Before 2020, It’s All About Name Recognition
| 2019-01-18 | [🔗](https://www.thecrosstab.com/2019/01/18/how-tax-rates-work-1970s/) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_18_how_marginal_tax_rates_work.R) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_18_how_marginal_tax_rates_work.R) | How Marginal Tax Rates Work
| 2019-01-25 | [🔗](https://www.thecrosstab.com/2019/01/25/counterintuitive-no-votes/) | [🔗](https://voteview.com/static/data/out/members/Hall_members.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_01_25_counterintuitive_no_votes.R) | What Happens To Our Algorithms When Socialists Vote in Congress
| 2019-02-01 | [🔗](https://www.thecrosstab.com/2019/02/01/distribution-of-voters/) | [🔗](https://www.voterstudygroup.org/data) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_01_distribution_of_voters.R) | The Ideological Diversity of the American Electorate
| 2019-02-08 | [🔗](https://www.thecrosstab.com/2019/02/08/how-liberal-2020-dems/) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_02_08_how_liberal_2020_dems.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_08_how_liberal_2020_dems.R) | Just How Liberal Are the 2020 Democratic Candidates?
| 2019-02-15 | [🔗](https://www.thecrosstab.com/2019/02/15/2020-twitter-primary/) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_02_15_2020_twitter_primary.Rdata) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_02_15_2020_twitter_primary.R) | The 2020 Twitter Primary





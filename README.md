# R for political data analysis

A repo to provide a central location for the files and data used in my [weekly posts](http://www.thecrosstab.com/) on analyzing political data in R. Inspired by the folks participating in [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday), I'm really intending this to be an introduction to techniques of data science that have real world applied use cases. Again, read more [on my blog](https://www.thecrosstab.com/project/r-for-political-data-science-weekly/). 

If you're looking for a more guided introduction to the topic, consider taking my course ["Analyzing Polling and Election Data in R" at DataCamp.com](https://www.datacamp.com/courses/analyzing-election-and-polling-data-in-r). And, of course, check out my R package [`politicaldata`](https://github.com/elliottmorris/politicaldata) that makes downloading and analyzing a lot of these data even easier.


# Housekeeping

- The `/data` subdirectory is a list of all the data used in each post, cleaned up and ready to be imported.
- The `/scripts` subdirectory contains scripts that analyze the datasets. These scripts are made of all the same code included in the posts, but the commentary is stripped away.

If your code doesn't work, make sure you've removed references to my personal R theme, `theme_elliott()`. Might I suggest replacing it with `theme_minimal()`. If you're still having trouble, open an issue with a reproducible example (which you can generate easily in R using [`reprex`](https://github.com/tidyverse/reprex)).

## Data and posts 

Here is a table of all the posts, data, and scripts in chronological order:

| Date | Post link | Data | Script | Title 
| - | - | - | - | -
| 2019-01-04 | [🔗](https://www.thecrosstab.com/2019/01/04/how-much-has-congress-polarized/) | [🔗](https://voteview.com/static/data/out/members/Hall_members.csv) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_04_polarization_in_congress.R) | Polarization in the 115h Congress
| 2019-01-11 | [🔗](https://www.thecrosstab.com/2019/01/11/2020-cnn-poll-favs/) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/data/2019_01_11_cnn_poll.csv) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_11_cnn_poll.R) | This Early Before 2020, It’s All About Name Recognition
| 2019-01-18 | [🔗](https://www.thecrosstab.com/2019/01/18/how-tax-rates-work-1970s/) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_18_how_marginal_tax_rates_work.R) | [🔗](https://github.com/elliottmorris/Rpolidata/blob/master/scripts/2019_01_18_how_marginal_tax_rates_work.R) | How Marginal Tax Rates Work
| 2019-01-25 | [🔗](https://www.thecrosstab.com/2019/01/25/counterintuitive-no-votes/) | [🔗](https://voteview.com/static/data/out/members/Hall_members.csv) | [🔗](https://github.com/elliottmorris/R-for-political-data/blob/master/scripts/2019_01_25_counterintuitive_no_votes.R) | What Happens To Our Algorithms When Socialists Vote in Congress
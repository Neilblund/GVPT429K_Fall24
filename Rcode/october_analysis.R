# Setup ------------------------------------------------------------------------
# if you haven't done so already, you'll want to run 
# usethis::edit_r_environ() 
# This will open a new file called .Renviron. 
#  Add the following lines to the .Renviron file:
#   ACLED_API_KEY = 'YOUR API KEY HERE'
#   ACLED_EMAIL = 'The email address you used to register here'
# When you're done, you can save the file and then restart R-studio. After that
# running Sys.getenv("ACLED_EMAIL") in R will retrieve your email address.


# libraries --------------------------------------------------------------------

library(tidyverse) # load the tidyverse
library(acled.api) # load the acled.api library

# downloading the data ---------------------------------------------------------
oct_events<-acled.api(
  email.address = Sys.getenv("ACLED_EMAIL"), 
  access.key = Sys.getenv("ACLED_API_KEY"),
  start.date = "2024-10-01", #  get events starting on this date
  end.date ="2024-10-17", #  get events ending on this date 
  all.variables = TRUE, 
  country = NULL # change this from country = NULL to something like "China" to filter a specific country
)

# once you have the data downloaded, you can save it to a file like this:
# readr::write_csv(oct_events, "oct_2024_events.csv")

# then you can reload it like this:
# oct_events <- readr::read_csv("oct_2024_events.csv")


#counting events----------------------------------------------------------------
# remember that you can use the count function to count categorical variables:

# counting events by type
oct_events|>
  count(event_type)

# counting events by type AND country

country_counts<-oct_events|>
  count(event_type, country)

# And you can user filter to keep a specific set of rows from a data set: 
# creating a data set that only includes violence against civilian by country
violence<-country_counts|>
  filter(event_type=='Violence against civilians')


# plotting ---------------------------------------------------------------------
# We can create a bar plot showing the amount of violence against civilians
# by country in October 2024: 

# Creating a barplot 
viol <- ggplot(violence, aes(x=country, y=n)) +
  # making it horizontal
  coord_flip() +
  # adding the bars (stat='identity') means: "the height should be determined by n"
  geom_bar(stat='identity') +
  # x axis label
  xlab("Country") +
  # y axis label
  ylab("Number of events") +
  # title and caption
  labs(title = "Incidents of violence against civilians in October 2024",
       caption = "Data source: ACLED") +
  # black-and-white theme
  theme_bw()

# view the plot you just made: 
viol

# save the plot under a file called "october_violence.png" with a height of 8
# and a width of 10 inches
ggsave(viol, filename='october_violence.png', width=10, height=8, units='in')



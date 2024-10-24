# making a plot of events over time in Hong Kong during the anti-ELAB protests
library(acled.api)
library(tidyverse)
library(paletteer) # color palettes
# Getting the data from ACLED -----

china_events<-acled.api(
  email.address = Sys.getenv("ACLED_EMAIL"), 
  access.key = Sys.getenv("ACLED_API_KEY"),  
  start.date = "2016-01-01",   # no coverage for this country prior to 2018              
  end.date =Sys.Date(),  # this gets everything until the current date
  country = "China", # for all of China
  all.variables = TRUE                      
)




# We have to just get everything for china, but we can filter to a sub-region
# within a country: 
hk_events <- china_events|>
  filter(admin1 == "Hong Kong")


## Aggregating by month -----
# We want to count events per month through the course of the protest, we 
# can create a "month" variable wih "floor_date", which takes a specific date
# and rounds it down the the first date of whatever we specify with the 'unit' 
# argument. So:
# 2024-09-13 becomes 2024-09-01
# 2024-10-02 becomes 2024-10-01
# 2024-11-11 becomes 2024-11-01
# ... etc
hk_events<-hk_events|>
  mutate(event_date = as.Date(event_date),  # tell R that this is a date variable
         month = floor_date(event_date, unit='month')
         
         )|>
  arrange(event_date)

# now we can count sub-events by date
monthly_events<-hk_events|>
  # we'll limit our analysis to protest/riot type events
  filter(event_type %in% c("Protests", "Riots"))|>
  # now group by month 
  group_by(month)|>
  # and count the number of each sub-event type
  count(sub_event_type)


## Making a bar plot----

# make a bar plot, but now the x-axis is "month" and the height is n, and the
# fill will be set according to the sub-event type: 
events_plot<-ggplot(monthly_events, aes(x=month, y=n, fill=sub_event_type)) + 
  geom_bar(stat='identity') +
  theme_bw() +
  # don't forget to add a title and caption
  ylab("Number of events")+ 
  labs(title = "Hong Kong protest events",
       caption = 'source: Armed Conflict Location & Event Data Project (ACLED); www.acleddata.com',
       
  )

# view the plot: 
events_plot


## Fancier bar plot ---------------------------------------------------------------
# Start by reordering the sub_event_types to change the appearance. 
# general syntax here is
# fct_relevel(variablename, "first level", "second level" , "third level" etc.)

monthly_events$sub_event_type <- fct_relevel(
  monthly_events$sub_event_type,
  "Mob violence",
  "Excessive force against protesters",
  "Violent demonstration",
  "Protest with intervention",
  "Peaceful protest"
)


events_plot_modified<-ggplot(monthly_events, aes(x=month, y=n, fill=sub_event_type)) + 
  geom_bar(stat='identity') +
  theme_minimal() +
  # date breaks every three months and month-year labels
  scale_x_date(date_breaks = "3 months" , date_labels = "%b-%y") +
  # horizontal tick marks
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  # rename the legend 
  labs(fill = 'Sub-event Type') +
  # change the color palette
  scale_fill_paletteer_d("ggthemes::colorblind")  +
  # adding descriptive labels
  ylab("Number of events")+ 
  labs(title = "Hong Kong protest events",
       caption = 'source: Armed Conflict Location & Event Data Project (ACLED); www.acleddata.com',
       
  )

events_plot_modified



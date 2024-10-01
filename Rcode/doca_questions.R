#Data import####################################################################
# This section of code will just import the DOCA data if you don't already have
# it in your current working directory. Ideally; your code from the previous class
# should allow you to do this!
# check for required packages and install if not available
required_packages<-c("tidyverse", "haven", "ggplot2")
for(p in required_packages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  
}

library(tidyverse) # general data manipulation
library(haven) # for importing .dta formatted files
library(ggplot2) # for graphing 

# if the file doesn't exist already, then download from website
if(!file.exists('final_data_v10.dta')){
  download.file('http://www.stanford.edu/group/collectiveaction/final_data_v10.dta', 
                dest='final_data_v10.dta',
                mode ='wb'
  )
  
}
# read in the data and treat it as a factor variable the encoding = 'latin1'
# should fix the error message that mac users were getting

doca<-read_dta('final_data_v10.dta', encoding='latin1')|>
  as_factor()|>
  # remove the one 1955 event: 
  filter(evyy>1955)

#Analysis#######################################################################



## Q1 ---- 
# Q: which column contains the year the event occurred and how do I access it? 
# A: according to the codebook, this is in the evyy column, we can access specific
#    columns of a dataframe using the $ notation: ie: data$column 

doca$evyy

## Q2 ----
# Q: How would I create a data set containing only the events where a
#    person was killed?

# A: I can use the filter() function to filter based on a logical expression:

docadeaths<-doca|>
  filter(deaths == 1)

nrow(docadeaths) # now we only have 366 rows


## Q3 ----
# Q: How would I calculate the number of events per year using the count function?
#    How would I calculate this for violent protests only?
# A: I could use the count function to count events by year 
doca|>
  count(evyy)


## Q4 ----
# Q: propdam is a dummy variable that indicates whether property damage occurred
#    at an event. smonamed is a dummy variable that indicates whether a social
#    movement organization was involved in the event. Is property damage more or
#    less likely at events where a social movement organization was involved?

# A: 


## Q5 ----
# Q: How would I recode the counter demonstrators variable to have a more 
#    descriptive label?

# A: 


## ggplot example:  ----
# plotting events by year
yearly_events<-doca|>
  count(evyy)

# date, aes(x=, y=) and then add geometry:
ggplot(yearly_events, aes(x=evyy, y=n)) + 
  geom_line() +
  xlab("Year") +
  ylab("Total events")

# plotting violent vs. nonviolent events by year:
yearly_events<-doca|>
  # adding a more descriptive version of the viold variable:
  mutate(violence = case_when(viold ==1 ~ "violence used", 
                              viold == 0 ~ "no violence used"
  ))|>
  count(evyy, violence)|>
  drop_na()

# date, aes(x=, y=) and then add geometry:
ggplot(yearly_events, aes(x=evyy, y=n, color=violence)) + 
  geom_line() +
  xlab("Year") +
  ylab("Total events")


# Tip: Ideally, you want to write scripts that can run from top to bottom. If
# you want to make sure your script is reproducible, you can restart R by
# clicking session -> Restart R in the menus at the top of the page. Then click
# the Source button at the top right of the source pane (or press
# CTRL+SHIFT+ENTER). If everything is working properly, the code should run
# with no errors. If something is out of place, the code will stop running and 
# give you an error message. 







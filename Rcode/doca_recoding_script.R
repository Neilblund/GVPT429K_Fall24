# This is an R script to download, clean, and give descriptive value labels to
# the Dynamics of Collective Action data set. You can run manually by copy-pasting
# into an R script, or by running:
# source("")

# check for required packages and install if not available
required_packages<-c("dplyr", "haven", "labelled", "jsonlite")
for(p in required_packages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  
}
library(dplyr) # data manipulation
library(haven) # package for importing stata format (.dta) files
library(labelled) # labelled vectors in R
library(jsonlite) # reading json formatted files

# importing the formatted codebook
speclist<-fromJSON("https://raw.githubusercontent.com/Neilblund/APAN/refs/heads/main/codebook.json")

labels<-speclist$labels


# if the file doesn't exist already, then download from website
if(!file.exists('final_data_v10.dta')){
  download.file('http://www.stanford.edu/group/collectiveaction/final_data_v10.dta', 
                dest='final_data_v10.dta',
                mode ='wb'
                )
  
}

doca<-read_dta('final_data_v10.dta', encoding='latin1')



# function to apply labels to variables
codebook<-function(var, labeler){
  vals<-labeler$code
  names(vals)<-labeler$label
  val_labels(var) <-vals
  return(var)
}

# applying labels to columns: 
for(i in 1:nrow(labels)){
  labs<-labels[i, ]
  col<-labs$`variable name`
  var_label(doca[[col]]) <- labs$`variable title`
  if(!is.na(labs$Rformat)){
    
    doca[[col]] <- codebook(doca[[col]], speclist[[labs$Rformat]])
  }
  
  
}

# adding general claim labels
doca<-doca|>
  mutate(across(matches('^claim[0-9]'), 
                .fns=~codebook(.x, speclist$general_claims), 
                .names='gen_{.col}'))

# converting to R factors
doca<-as_factor(doca)

# removing the 1955 case
doca<-doca[which(doca$evyy>1955),]

# adding event date column
doca$event_date<-with(doca, as.Date(paste(evyy, evmm, evdd, sep='-')))



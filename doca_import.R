required_packages<-c("haven")
for(p in required_packages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  
}

if(!file.exists('final_data_v10.dta')){
  download.file('http://www.stanford.edu/group/collectiveaction/final_data_v10.dta', 
                dest='final_data_v10.dta',
                mode ='wb'
  )
  
}

doca<-read_dta('final_data_v10.dta', encoding='latin1')
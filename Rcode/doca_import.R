
if(!("haven" %in% installed.packages())){
  install.packages('haven')
}


if(!file.exists('final_data_v10.dta')){
  download.file('http://www.stanford.edu/group/collectiveaction/final_data_v10.dta', 
                dest='final_data_v10.dta',
                mode ='wb'
  )
  
}

doca<-haven::read_dta('final_data_v10.dta', encoding='latin1')


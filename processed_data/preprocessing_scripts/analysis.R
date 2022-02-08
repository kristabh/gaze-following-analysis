## Gaze following analysis and visualizations

# clear the workspace
rm(list=ls())

# load packages
if(!require("Jmisc")) {install.packages("Jmisc")}
library(Jmisc)

# set working directory
workdir <- '~/Gaze following/'

# the labs
labs <- list.files(paste0(workdir, 'data_analysis/'))

# load analysis and visualization functions
sourceAll(paste0(workdir, 'R_functions'))

# loop through the data of all labs
for(lab in labs){
  # for the koku-hamburg lab there are 2 files that need to be analyzed
  if(lab == 'koku-hamburg'){
    for(i in c("12-15mos", "6-9mos")){
      # load the data
      load(paste0(workdir, 'data_analysis/', lab, '/', i, '/', lab, '_', i, '.Rdata'))
      lab_data <- get(paste0(lab, '_', i))
      
      # do analysis
      analyze_data(lab_data)
      # visualize AOIs
      visualize_AOI(lab_data)
      # visualize data
      visualize_data(lab_data)
      
      print(lab)
    }
  } else {
    # load the data
    load(paste0(workdir, 'data_analysis/', lab, '/', lab, '.Rdata'))
    lab_data <- get(lab)
    
    # do analysis
    analyze_data(lab_data)
    # visualize AOIs
    visualize_AOI(lab_data)
    # visualize data
    visualize_data(lab_data)
    
    print(lab)
  }
}




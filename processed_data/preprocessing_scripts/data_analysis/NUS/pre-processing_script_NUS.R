### Gaze Following
# clear workspace
rm(list=ls())

# load (and if not available install) the libraries
if(!require("rmarkdown")) {install.packages("rmarkdown")}
if(!require("gazepath")) {install.packages("gazepath")}
if(!require("scales")) {install.packages("scales")}
if(!require("SDMTools")) {install.packages("SDMTools")}
if(!require("png")) {install.packages("png")}
if(!require("writexl")) {install.packages("writexl")}

library(rmarkdown)
library(gazepath)
library(scales)
library(SDMTools)
library(png)
library(writexl)

# set working directory to the correct folder
wd <- '~/Gaze following/data_analysis/NUS/'

# define the variables
# lab id
LAB <- 'NUS'

# The variables that define the position (in pixels) and the distance (in mm)
# should get the names they have in the data frame that was just loaded
LEFT_EYE_X <- "GazePointLeftX..ADCSpx."
LEFT_EYE_Y <- "GazePointLeftY..ADCSpx."

RIGHT_EYE_X <- "GazePointRightX..ADCSpx."
RIGHT_EYE_Y <- "GazePointRightY..ADCSpx."

DIST_LEFT <- "DistanceLeft"
DIST_RIGHT <- "DistanceRight"

# The variables that define each trial and each participant are also required
TRIAL_NAME <- "MediaName"
PARTICIPANT <- "ParticipantName"

# There are also general variables, such as screen dimension (in both pixels and mm),
# stimuli dimensions (in pixels) and samplerate. These can be assigned directly
SCREEN_RES_WIDTH_PX <- 1600
SCREEN_RES_HEIGHT_PX <- 1200

SCREEN_WIDTH_mm <- 570
SCREEN_HEIGHT_MM <- 370

STIM_WIDTH_PX <- 1600
STIM_HEIGHT_PX <- 1200

SAMPLERATE <- 60

## read the data for the 4 orders
newd <- list()
for(i in 1:4){
  files <- list.files(paste0(wd, 'order', i, '/'), pattern = '.tsv')
  
  # read in the Tobii data and combine into 1 data frame
  da <- numeric()
  for(file in files){
    da <- rbind(da, read.delim(paste0(wd, 'order', i, '/', file)))
  }
  
  # Using these variables we can create a data frame (d) with only the neccesary variables
  d <- da[,c(LEFT_EYE_X, LEFT_EYE_Y, 
             RIGHT_EYE_X, RIGHT_EYE_Y, 
             DIST_RIGHT, DIST_LEFT, 
             TRIAL_NAME, PARTICIPANT)]
  
  # Assign the names to the data frame
  names(d) <- c('LEFT_EYE_X', 'LEFT_EYE_Y', 
                'RIGHT_EYE_X', 'RIGHT_EYE_Y', 
                'DIST_RIGHT', 'DIST_LEFT', 
                'TRIAL_NAME', 'PARTICIPANT')
  
  # Set unreliable data points (as indicated by Validity measure) to NA
  if('ValidityLeft' %in% names(da)){
    d[-which(da$ValidityLeft == 0), 1:2] <- NA
    d[-which(da$ValidityRight == 0), 3:4] <- NA
  } 
  
  # select relevant trials (omit attention getters)
  d <- d[grep('_T', d$TRIAL_NAME),]
  
  # Create a variable that names the trials 1 - 6
  d$TRIAL <- as.numeric(sub('_T', '', substr(as.character(d$TRIAL_NAME), 5, 7)))
  
  # Create the order variable
  d$ORDER <- as.numeric(substr(d$TRIAL_NAME, 4, 4))
  newd[[i]] <- d
  print(i)
}

# combine into 1 variable
d <- do.call('rbind', newd)

# Make sure the position data is numeric and ',' are transformed to '.'
for(i in 1:6){
  d[,i] <- gsub(',', '.', d[,i])
  d[,i] <- as.numeric(as.character(d[,i]))
}

# Assign new names to the columns of the data
names(d) <- c('LX', 'LY', 'RX', 'RY', 'DR', 'DL', 'TRIAL_NAME', 'PP_NAME', 'TRIAL_INDEX', 'ORDER')

# There is an possible issue with double PP id's
dbl <- rle(as.vector(d$PP_NAME))$val[duplicated(rle(as.vector(d$PP_NAME))$val)]
# Participants "MBG015" and "MBG030" appear in both order 1 and order 3
# Therefore we leave them out of the analysis

d <- d[!d$PP_NAME %in% dbl,]

## Now all data is available to run the analyses
# first create an empty data frame to store the results
output_data <- data.frame()

# then run through all participants to do the analyses (can take a while with many participants)
for(pp in unique(d$PP_NAME)){
  ## select the data of the current participant
  pp_data <- d[d$PP_NAME == pp,]
  ## run gazepath
  test <- gazepath(pp_data, x1 = 'LX', y1 = 'LY', x2 = 'RX', y2 = 'RY', d1 = 'DL', d2 = 'DR', 
                   trial = 'TRIAL_INDEX', height_px = STIM_HEIGHT_PX, height_mm = SCREEN_HEIGHT_MM, 
                   width_px = STIM_WIDTH_PX, width_mm = SCREEN_WIDTH_mm, method = 'gazepath', 
                   res_x = SCREEN_RES_WIDTH_PX, res_y = SCREEN_RES_HEIGHT_PX, 
                   samplerate = SAMPLERATE, thres_dur = 100, extra_var = c('TRIAL_NAME','PP_NAME'))
  ## Summary of fixations
  s <- summary(test, fixations_only = T)
  ## save the fixations in the output data frame
  if(!is.null(dim(s))) output_data <- rbind(output_data, s) else print(pp)
}

# inspect the data
## Define AOI
AOI_left <- matrix(c(10, 310,
                     10, 565,
                     220, 565,
                     220, 310), 4, 2, T)
AOI_right <- matrix(c(500, 310,
                      500, 565,
                      710, 565,
                      710, 310), 4, 2, T)
AOI_face <- matrix(c(230, 50,
                     230, 410,
                     490, 410,
                     490, 50), 4, 2, T)
## plot the fixations
plot(output_data[,5:6], xlim = c(0, SCREEN_RES_WIDTH_PX), ylim = c(SCREEN_RES_HEIGHT_PX, 0))

## add the AOI, these are defined in 720x576 dimensions and have to be enlarged
## and possibly moved to match the screen dimensions
# scale factor
sf <- SCREEN_RES_HEIGHT_PX / 576
# offset factor
of <- (SCREEN_RES_WIDTH_PX - 720 * sf) / 2
# calculate aoi's
aoif <- AOI_face * sf + matrix(c(rep(of, 4), 0,0,0,0), 4, 2)
aoil <- AOI_left * sf + matrix(c(rep(of, 4), 0,0,0,0), 4, 2)
aoir <- AOI_right * sf + matrix(c(rep(of, 4), 0,0,0,0), 4, 2)
# add aoi's to plot
polygon(aoif)
polygon(aoil)
polygon(aoir)

# extend the data frame with variables that code whether or not there was a fixations
# in any of the AOI's. This data frame contains all information to derive the final measures
output_data$AOI_LEFT <- pnt.in.poly(output_data[,5:6], aoil)[,3]
output_data$AOI_RIGHT <- pnt.in.poly(output_data[,5:6], aoir)[,3]
output_data$AOI_FACE <- pnt.in.poly(output_data[,5:6], aoif)[,3]

# add the congruent and incongruent information
output_data$congruent <- substr(output_data$TRIAL_NAME, 9, 9)
output_data$congruent_AOI <- ifelse(output_data$congruent == 'R', output_data$AOI_RIGHT, output_data$AOI_LEFT)
output_data$incongruent_AOI <- ifelse(output_data$congruent == 'L', output_data$AOI_RIGHT, output_data$AOI_LEFT)


# save the data
assign(LAB, list(d, output_data, aoir, aoil, aoif, SCREEN_RES_HEIGHT_PX, 
                 SCREEN_RES_WIDTH_PX, STIM_HEIGHT_PX, STIM_WIDTH_PX, SAMPLERATE,
                 LAB, wd))

save(list = LAB, file = paste0(wd, LAB, '.Rdata'))



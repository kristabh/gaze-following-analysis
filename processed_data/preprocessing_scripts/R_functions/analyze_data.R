## analyze the data

library(writexl)

analyze_data <- function(x){
  d <- x[[1]]
  output_data <- x[[2]]
  aoir <- x[[3]]
  aoil <- x[[4]]
  aoif <- x[[5]]
  SCREEN_RES_HEIGHT_PX <- x[[6]] 
  SCREEN_RES_WIDTH_PX <- x[[7]]
  STIM_HEIGHT_PX <- x[[8]]
  STIM_WIDTH_PX <- x[[9]]
  SAMPLERATE <- x[[10]]
  LAB <- x[[11]] 
  wd <- '~/Gaze following/processed_data/'

  # initialize a data frame to store the gaze shifts and dwell times
  N_pp <- length(unique(d$PP_NAME))
  trials <- sapply(unique(d$PP_NAME), function(pp) length(unique(d$TRIAL_NAME[d$PP_NAME == pp])))
  len <- sum(trials)
  
  template_data <- data.frame(matrix(NA, len, 13))
  names(template_data) <- c("lab", "subid", "study_order", "stimulus", "trial_num", "first_shift", 
                            "latency", "n_shift_congruent", "n_shift_incongruent", "fixation_congruent", 
                            "fixation_incongruent", "trial_error", "trial_error_type")
  
  template_data$lab <- LAB
  template_data$subid <- rep.int(unique(d$PP_NAME), times = trials)
  template_data$trial_num <- as.vector(unlist(sapply(trials, function(x) 1:x)))
  
  template_data$stimulus <- aggregate(TRIAL_NAME ~ TRIAL_INDEX + PP_NAME, data = d, FUN = function(i) head(i, 1))[,3]
  template_data$study_order <- as.numeric(substr(template_data$stimulus, 4, 4))
  
  # Calculate the gaze shifts and other variables for every baby on every trial
  # loop through all babies
  for(pp in unique(output_data$PP_NAME)){
    # and through all trials
    for(trial in 1:6){
      # indexing shortcut for the template data
      ii <- template_data$subid == pp & template_data$trial_num == trial
      
      # select the data for the baby and trial
      trial_data <- output_data[output_data$PP_NAME == pp & output_data$Trial == trial,]
      # omit all data from the first 4 seconds
      trial_data <- trial_data[trial_data$End > 4000,]
      # check if there is any data
      if(nrow(trial_data) == 0){
        # keep all variables at NA and move on to next trial
      } else {
        if(nrow(trial_data) == 1){
          # with 1 data point gaze shifts are not possible, but fixations are
          template_data$fixation_congruent[ii] <- sum(trial_data$Duration[trial_data$congruent_AOI == 1])
          template_data$fixation_incongruent[ii] <- sum(trial_data$Duration[trial_data$incongruent_AOI == 1])
        } else {
          # Total duration of congruent fixations
          runlen <- rle(trial_data$congruent_AOI)
          DUR <- 0
          for(x in which(runlen$values == 1)){
            start <- cumsum(runlen$lengths)[x] - runlen$lengths[x] + 1
            end <- cumsum(runlen$lengths)[x]
            duration_x <- trial_data$End[end] - trial_data$Start[start]
            DUR <- DUR + duration_x
          }
          template_data$fixation_congruent[ii] <- DUR
          # Total duration of incongruent fixations
          runlen <- rle(trial_data$incongruent_AOI)
          DUR <- 0
          for(x in which(runlen$values == 1)){
            start <- cumsum(runlen$lengths)[x] - runlen$lengths[x] + 1
            end <- cumsum(runlen$lengths)[x]
            duration_x <- trial_data$End[end] - trial_data$Start[start]
            DUR <- DUR + duration_x
          }
          template_data$fixation_incongruent[ii] <- DUR
          
          # indicate which shift were congruent and incongruent
          SHIFT_CON <- c(F, (trial_data$AOI_FACE[-nrow(trial_data)] + trial_data$congruent_AOI[-1]) == 2)
          SHIFT_IN <- c(F, (trial_data$AOI_FACE[-nrow(trial_data)] + trial_data$incongruent_AOI[-1]) == 2)
          # sum for the number of shifts
          template_data$n_shift_congruent[ii] <- sum(SHIFT_CON)
          template_data$n_shift_incongruent[ii] <- sum(SHIFT_IN)
          
          
          first_con <- ifelse(length(which(SHIFT_CON)) == 0,  NA, which(SHIFT_CON)[1])
          first_in <- ifelse(length(which(SHIFT_IN)) == 0,  NA, which(SHIFT_IN)[1])
          # check if there are any shift and to which side
          shift <- ifelse(is.na(first_con) & is.na(first_in), NA,
                          ifelse(is.na(first_con), 'incongruent',
                                 ifelse(is.na(first_in), 'congruent',
                                        ifelse(first_con < first_in, 'congruent', 'incongruent'))))
          
          template_data$first_shift[ii] <- shift
          
          shifts <- c(first_con, first_in)
          
          
          if(sum(is.na(shifts)) < 2){
            template_data$latency[ii] <- trial_data$Start[min(shifts, na.rm = T)]
          }
        }
      }
    }
  }
  
  # write the data to a csv file
  write_xlsx(template_data, paste0(wd, 'data_', LAB, '.xlsx'))
  
}


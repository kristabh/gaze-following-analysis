## make plots to inspect data quality

library(ggplot2)
library(RColorBrewer)

visualize_data <- function(x){
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
  wd <- '~/Gaze following/visualizations/'

  p <- list()
  for(pp in unique(d$PP_NAME)){
    fd <- output_data[output_data$PP_NAME == pp,]
    rd <- d[d$PP_NAME == pp,]
    rd$time <- as.vector(unlist(sapply(rle(rd$TRIAL_INDEX)$len, function(x) 1:x))) / SAMPLERATE
    
    p[[pp]] <- list()
    for(trial in unique(fd$Trial)){
      fdt <- fd[fd$Trial == trial,]
      rdt <- rd[rd$TRIAL_INDEX == trial,]
      
      colourCount = nrow(fdt)
      getPalette = colorRampPalette(brewer.pal(9, "Paired"))
      
      colY <- head(brewer.pal(11, "RdYlBu"), 2)
      colX <- tail(brewer.pal(11, "RdYlBu"), 2)
      
      p[[pp]][[trial]] <- ggplot(data = rdt, aes(x = LX, y = time)) + 
        ylim(tail(rdt$time, 1), 0) + xlim(aoil[1,1], aoir[3,1]) +
        annotate('rect', xmin=aoif[1,1], xmax=aoif[3,1], ymin=-Inf, ymax=4, fill = 'blue', alpha = .2) + 
        annotate('rect', xmin=aoil[1,1], xmax=aoil[3,1], ymin=4, ymax=Inf, fill = ifelse(fdt$congruent[1] == 'L', 'green', 'red')
                 , alpha = .2) + 
        annotate('rect', xmin=aoir[1,1], xmax=aoir[3,1], ymin=4, ymax=Inf, fill = ifelse(fdt$congruent[1] == 'R', 'green', 'red')
                 , alpha = .2) +
        annotate('rect', xmin=fdt$mean_x - 25, xmax=fdt$mean_x + 25, ymin=fdt$Start/1000, ymax=fdt$End/1000, 
                 fill = getPalette(colourCount), alpha = .7, col = 'black') +
        geom_path(data = rdt, aes(x = LX, col = colX[1]), na.rm = T) + 
        geom_path(data = rdt, aes(x = RX, col = colX[2]), na.rm = T) +
        geom_path(data = rdt, aes(x = LY, col = colY[1]), na.rm = T) +
        geom_path(data = rdt, aes(x = RY, col = colY[2]), na.rm = T) +
        labs(title = paste('Participant =', pp, ' ~  Trial =', fdt$TRIAL_NAME[1]),
             x = 'X- and Y-coordinates', y = 'Time (seconds)') + 
        scale_color_manual(values=c(colX, colY),
                           breaks=c(colX, colY),
                           name="Raw data\nsignal",
                           labels=c("Left eye X", "Right eye X", "Left eye Y", "Right eye Y")) +
        theme_minimal()
    }
  }
  
  pdf(paste0(wd, 'visualize_', LAB, '.pdf'), onefile = TRUE)
  for(pp in unique(d$PP_NAME)){
    if(length(p[[pp]]) > 0) f <- lapply(p[[pp]], function(x) if(!is.null(x)) plot(x))
  }
  dev.off()
}


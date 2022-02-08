## Plot AOI function
visualize_AOI <- function(x){
  output_data <- x[[2]]
  aoir <- x[[3]]
  aoil <- x[[4]]
  aoif <- x[[5]]
  SCREEN_RES_HEIGHT_PX <- x[[6]] 
  SCREEN_RES_WIDTH_PX <- x[[7]]
  LAB <- x[[11]] 
  wd <- '~/Gaze following/AOIs/'
  
  pdf(paste0(wd, 'visualize_AOIs_', LAB, '.pdf'), height = 10, width = 10)
  plot(output_data[,5:6], xlim = c(0, SCREEN_RES_WIDTH_PX), ylim = c(SCREEN_RES_HEIGHT_PX, -300), 
       las = 1, bty='n', asp = 1, col = 'darkgrey', axes = F, xlab = 'X (pixel)', ylab = 'Y (pixel)')
  polygon(aoif)
  polygon(aoil)
  polygon(aoir)
  aoif <- round(aoif, 2)
  aoil <- round(aoil, 2)
  aoir <- round(aoir, 2)
  rect(0, SCREEN_RES_HEIGHT_PX, SCREEN_RES_WIDTH_PX, 0)
  text(SCREEN_RES_WIDTH_PX/2,-300, paste0('Left AOI ~ Top left corner (', aoil[1,1], ',', aoil[1,2], ') -- Bottom right corner (', aoil[3,1], ',', aoil[3,2], ')'))
  text(SCREEN_RES_WIDTH_PX/2,-200, paste0('Face AOI ~ Top left corner (', aoif[1,1], ',', aoif[1,2], ') -- Bottom right corner (', aoif[3,1], ',', aoif[3,2], ')'))
  text(SCREEN_RES_WIDTH_PX/2,-100, paste0('Right AOI ~ Top left corner (', aoir[1,1], ',', aoir[1,2], ') -- Bottom right corner (', aoir[3,1], ',', aoir[3,2], ')'))
  axis(1, round(seq(0, SCREEN_RES_WIDTH_PX, length.out = 10)))
  axis(2, round(seq(0, SCREEN_RES_HEIGHT_PX, length.out = 10)), las = 1)
  dev.off()
}


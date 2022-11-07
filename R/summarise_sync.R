#' Summarise synchronies
#'
#' This function summarises the calculated asynchronies.
#'
#' @param df data frame to be processed
#' @param relative Whether calculation is relative measure
#' @return Integer output
#' @import tidyr
#' @import magrittr

summarise_sync <- function(df=NULL,relative=FALSE){

  # T. Eerola, Durham University, IEMP project
  # 20/6/2022
  #Instrument <- ms <- beatL <- NULL
  
  d_in_ms <- df$asynch * 1000 # convert to ms
  asynch <- NULL  
  if(relative==FALSE){
    asynch$pairwise_asynchronization <- sd(d_in_ms)
    asynch$mean_absolute_asynchrony <- mean(abs(d_in_ms))
    asynch$groupwise_asynchronization <- sqrt(mean(d_in_ms))
    asynch$mean_pairwise_asynchrony <- mean(d_in_ms)
  }
  if(relative==TRUE){
    asynch$mean_pairwise_asynchrony <- mean(d_in_ms)
  }
  # # Mean relative asynchrony requires computing the mean
  # CSS_Song2 <- dplyr::select(CSS_Song2,-Isochronous.SD.Time)
  # CSS_Song2 <- add_isobeats(df = CSS_Song2, 
  #                           instr = c('Guitar','Bass','Tres','Clave'), 
  #                           beat = 'SD')
  # # then comparing clave and bass to this
  # d_clave <- sync_sample_paired(CSS_Song2,'Clave','Isochronous.SD.Time',
  #                               N=0,beat = 'SD')
  # d_bass <- sync_sample_paired(CSS_Song2,'Bass','Isochronous.SD.Time',
  #                              N=0,beat = 'SD')
  # asynch$MS[5] <- mean(c(d_clave$asynch*1000,d_bass$asynch*1000))
  
  
return <- asynch
  
}

#' Summarise synchronies
#'
#' This function summarises the calculated asynchronies.
#'
#' @param df data frame to be processed
#' @return Integer output
#' @import tidyr
#' @import magrittr

summarise_sync <- function(df=NULL){

  # T. Eerola, Durham University, IEMP project
  # 20/6/2022
  #Instrument <- ms <- beatL <- NULL
  
  d_in_ms <- df$asynch * 1000 # convert to ms
  asynch <- NULL  
  asynch$`Pairwise asynchronization` <- sd(d_in_ms)
  asynch$`Mean absolute asynchrony` <- mean(abs(d_in_ms))
#   asynch$groupwise_asynchronization <- sqrt(mean(d_in_ms))
  asynch$`Mean pairwise asynchrony` <- mean(d_in_ms)
  asynch <- data.frame(asynch, check.names = FALSE)
  print(colnames(asynch))
#  colnames(asynch)<-c('Pairwise asynchronization','Mean absolute asynchrony','Mean pairwise asynchrony') # Prettify
return <- asynch
  
}

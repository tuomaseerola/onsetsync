#' Calculate asynchronies across all pairs of instruments
#'
#' \code{sync_execute_pairs} is a meta-function that
#' executes calculations of asynchronies across all pairs of
#' instruments. One can specify the same options as in
#' \code{sync_sample_paired}.
#'
#' @param df data frame to be processed
#' @param instruments Instrument names to be processed
#' @param n Number of samples to be drawn from the pool of joint onsets
#' @param bootn How many bootstraps are drawn (NULL default)
#' @param beat Beat structure (subdivisions) to be included
#' @return Output contain asynchronies and beat levels
#' @seealso \code{\link{sync_sample_paired}}
#' @import ggplot2
#' @import tidyr
#' @import magrittr

sync_execute_pairs <- function(df = NULL,
                               instruments = NULL,
                               n = 0,
                               bootn = NULL,
                               beat = NULL){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  
  
  if(is.null(bootn)==TRUE){
    bootn <- 1
  }
  
  # Get all combinations
  c <- combn(instruments,2)
#  print(c)
  N <- dim(c)[2]
#  print(N)
  col_labels <- t(c)
  COL_LABELS<-NULL
  for(k in 1:N){
    COL_LABELS[k] <- paste(col_labels[k,1],'-',col_labels[k,2])
  }
  
  DF<-NULL
  BE<-NULL
  for(k in 1:N){
#    print(paste('k:',k,'1:',c[,k][1],'2:',c[,k][2],'3:',n,'4:',bootn,'5:',beat))
    DF <- cbind(DF,sync_sample_paired(df,c[,k][1],c[,k][2],n,bootn,beat,FALSE)$asynch)
    BE <- cbind(BE,sync_sample_paired(df,c[,k][1],c[,k][2],n,bootn,beat,FALSE)$beatL)
  }
  DF <- data.frame(DF)
  colnames(DF) <- COL_LABELS
  
  BE <- data.frame(BE)
  colnames(BE) <- COL_LABELS
  
return <- list(asynch=DF,beatL=BE)
}

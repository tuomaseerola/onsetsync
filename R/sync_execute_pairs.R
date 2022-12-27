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

  if(n < bootn & bootn>1){
    stop("More bootstraps (bootn) are specified than samples (n)!", call. = FALSE)
  }
  
  # Get all combinations
  c <- combn(instruments,2)
  #print(c)
  N <- dim(c)[2]
  #print(N)
  col_labels <- t(c)
  COL_LABELS<-NULL
  for(k in 1:N){
    COL_LABELS[k] <- paste(col_labels[k,1],'-',col_labels[k,2])
  }
  
  DF <- NULL
  BE <- NULL
  DF2 <- list()
  BE2 <- list()
  for(k in 1:N){
    if(n == 0){
      n_joint <- sync_joint_onsets(df,c[,k][1],c[,k][2])
#      print(paste('k:',k,'in1:',c[,k][1],'in2:',c[,k][2],'n:',n_joint,'bootn:',bootn,'beat:',beat))
      DF2[[k]] <- sync_sample_paired(df,c[,k][1],c[,k][2],n_joint,bootn,beat,FALSE)$asynch
      BE2[[k]] <- sync_sample_paired(df,c[,k][1],c[,k][2],n_joint,bootn,beat,FALSE)$beatL
    }
    else {
#      print(paste('k:',k,'in1:',c[,k][1],'in2:',c[,k][2],'n:',n,'bootn:',bootn,'beat:',beat))
      DF2[[k]] <- sync_sample_paired(df,c[,k][1],c[,k][2],n,bootn,beat,FALSE)$asynch
      BE2[[k]] <- sync_sample_paired(df,c[,k][1],c[,k][2],n,bootn,beat,FALSE)$beatL
      #DF <- cbind(DF,sync_sample_paired(df,c[,k][1],c[,k][2],n,bootn,beat,FALSE)$asynch)
      #BE <- cbind(BE,sync_sample_paired(df,c[,k][1],c[,k][2],n,bootn,beat,FALSE)$beatL)
    }
  }

  # collapse the pairs which are different lengths into the same data.frame with NAs
  if(n == 0){
    DF<-sapply(DF2, "length<-", max(lengths(DF2)))
    BE<-sapply(BE2, "length<-", max(lengths(BE2)))
  }
  else {
    DF<-sapply(DF2, "length<-", max(lengths(DF2)))
    BE<-sapply(BE2, "length<-", max(lengths(BE2)))
  }
  
  DF <- data.frame(DF)
  colnames(DF) <- COL_LABELS
  
  BE <- data.frame(BE)
  colnames(BE) <- COL_LABELS
  
return <- list(asynch=DF,beatL=BE)
}

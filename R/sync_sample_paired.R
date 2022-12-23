#' Take equal number of samples from two instruments
#'
#' taken N samples of two instruments (where they both have onsets)
#'
#' @param df data frame to be processed
#' @param instr1 Instrument 1 name to be processed
#' @param instr2 Instrument 2 name to be processed
#' @param n Number of samples to be drawn from the pool of joint onsets. If 0, do not sample (default)
#' @param bootn How many bootstraps are drawn (default none, which is 1)
#' @param beat Beat structure (subdivisions) to be included
#' @param verbose Display no. of shared onsets (default FALSE)
#' @seealso \code{\link{sync_execute_pairs}}
#' @return List containing asynchronies and beat structures
#' @export

sync_sample_paired <- function(df = NULL,
  instr1 = NULL,
  instr2 = NULL, 
  n = 0,
  bootn = NULL,
  beat = NULL,
  verbose = FALSE){

  # T. Eerola, Durham University, IEMP project
  # 14/1/2018  
  # Updated 18/6/2022 to incorporate corpus structure

  if(is.data.frame(df)==TRUE){
  
  inst1 <- as.matrix(df[,which(colnames(df)==instr1)])  
  inst2 <- as.matrix(df[,which(colnames(df)==instr2)])  
  beat <- as.matrix(df[,which(colnames(df)==beat)])

    if(is.null(bootn)==TRUE){
      bootn <- 1
    }
  
  D <- NULL
  if(bootn==1){
    ind<-!is.na(inst1) & !is.na(inst2)
    len_joint<-length(which(ind))
    if(verbose==TRUE){
      print(paste('onsets in common:',len_joint))
    }
    
    
    
    if(len_joint > n){
      if(n==0){
        if(verbose==TRUE){
          print(paste('take all onsets:',len_joint))
        }
        sample_ind <- which(ind)
      }
      if(n>0){
        sample_ind <- sample(which(ind),n)
      }
      d<-inst1[sample_ind]-inst2[sample_ind]
      D<-d
      beat_L<-beat[sample_ind]
      

    }
    if(len_joint <= n){
      D<-NA
      beat_L<-NA
    }
  }
  if(bootn>1){
    ind<-!is.na(inst1) & !is.na(inst2)
    len_joint<-length(which(ind))
    if(verbose==TRUE){
      print(paste('onsets in common:',len_joint))
    }
    if(len_joint>n){
      for(k in 1:bootn){
        ind<-!is.na(inst1) & !is.na(inst2)
        sample_ind <- sample(which(ind),n)
        d <- inst1[sample_ind]-inst2[sample_ind]
        D <-c(D,d)
        beat_L<-beat[sample_ind]
      }
    }
    if(len_joint<=n){
      D<-NA
      beat_L<-NA
    }    
  }
  
  } # ends normal single df processing
  
  if(is.data.frame(df)==FALSE){
#    print('Calculating across the corpora') # This is not very effective, but  
    NAMES<-names(df)
    D<-list()
    L<-NULL
    for (i in 1:length(df)) {
      tmp_df <- df[[i]]
      D[[i]] <- sync_sample_paired(df = tmp_df,instr1,instr2,n,bootn,beat)
      beat_L<-NULL
      L[i] <- length(D[[i]]$asynch)
    }
    R3<-dplyr::bind_rows(D)
    NAME_INDEX<-NULL
    for (x in 1:length(L)) {
      V<-rep(NAMES[x],L[x])
      NAME_INDEX<-c(NAME_INDEX,V)
    }
    R3$name<-NAME_INDEX
    D<-R3
  }
  
  return <- list(asynch=D,beatL=beat_L)  
}

#' onsetsynch_sample_paired
#'
#' taken N samples of two instruments (where they both have onsets)
#'
#' @param df data frame to be processed
#' @param instr1 Instrument 1 name to be processed
#' @param instr2 Instrument 2 name to be processed
#' @param N Number of samples to be drawn from the pool of joint onsets. If 0, do not sample!
#' @param Bnum How many bootstraps are drawn
#' @param beat Beat structure to be included
#' @param verbose Display no. of shared onsets (default FALSE)
#' @return List containing asynchronies and beat structures
#' @export

onsetsynch_sample_paired <- function(df,INSTR1,INSTR2, N=100,BNum=1,beat,verbose=FALSE){
  # was sampled_paired_asynchrony
  
  # T. Eerola, Durham University, IEMP project
  # 14/1/2018  
  
  instr1<-as.matrix(df[,which(colnames(df)==INSTR1)])  
  instr2<-as.matrix(df[,which(colnames(df)==INSTR2)])  
  beat<-as.matrix(df[,which(colnames(df)==beat)])  
  
  #N <- 100
  D <- NULL
  if(BNum==1){
    ind<-!is.na(instr1) & !is.na(instr2)
    len_joint<-length(which(ind))
    if(verbose==TRUE){
      print(paste('onsets in common:',len_joint))
    }
    
    
    
    if(len_joint > N){
      if(N==0){
        print(paste('take all onsets:',len_joint))
        sample_ind <- which(ind)
      }
      if(N>0){
        sample_ind <- sample(which(ind),N)
      }
      d<-instr1[sample_ind]-instr2[sample_ind]
      D<-d
      beat_L<-beat[sample_ind]
      
      ## STATS START
      #s<-data.frame(v1=instr1[sample_ind] - instr2[sample_ind],beat=beat_L)
      #a1<-t.test(s$v1)
      #a2<-summary(aov(v1~beat,data=s))
      ## STATS END
    }
    if(len_joint <= N){
      D<-NA
      beat_L<-NA
    }
  }
  if(BNum>1){
    ind<-!is.na(instr1) & !is.na(instr2)
    len_joint<-length(which(ind))
    if(verbose==TRUE){
      print(paste('onsets in common:',len_joint))
    }
    if(len_joint>N){
      for(k in 1:BNum){
        ind<-!is.na(instr1) & !is.na(instr2)
        sample_ind <- sample(which(ind),N)
        d <- instr1[sample_ind]-instr2[sample_ind]
        D <-c(D,d)
        beat_L<-beat[sample_ind]
      }
    }
    if(len_joint<=N){
      D<-NA
      beat_L<-NA
    }    
  }
  
  return<-list(asynch=D,beatL=beat_L)
}

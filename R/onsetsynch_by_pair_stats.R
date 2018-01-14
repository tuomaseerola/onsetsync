#' stats for asynchronies by pairs
#'
#' This function calculates simple t-test of the asynchronies of instruments (whether it differs from zero)
#'
#' @param df data frame to be processed
#' @param bybeat logical value whether beat information is used
#' @return Statistics output
#' @export

onsetsynch_by_pair_stats <-function(df,bybeat=FALSE){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  
  
  
  if(bybeat==FALSE){ # asynchronies
    
    m<-reshape2::melt(df$asynch)
    m$value<-m$value*1000
    colnames(m)<-c('Instrument','ms')
   # head(m)
    
    # check whether instrument is different from 0
    L<-levels(m$Instrument)
    L
    T<-NULL
    for(k in 1:length(L)){
      tmp<-m$ms[m$Instrument==L[k]]
      if(sum(is.na(tmp))<length(tmp)){
        t<-t.test(tmp,mu=0)
        T$tval[k]<-as.numeric(t$statistic)
        T$pval[k]<-as.numeric(t$p.value)
      }
      if(sum(is.na(tmp))==length(tmp)){
        T$tval[k]<-NA
        T$pval[k]<-NA
      }
    }
  }
  
  if(bybeat==TRUE){
    m<-reshape2::melt(df$asynch)
    m$value<-m$value*1000
    colnames(m)<-c('Instrument','ms')
    head(m)
    b<-reshape2::melt(df$beatL)
    m$beatL<-b$value
    str(m)
    m$beatL<-factor(m$beatL)
    
    
    L<-levels(m$Instrument)
    L
    T<-NULL
    for(k in 1:length(L)){
      tmp<-dplyr::filter(m, Instrument==L[k])
      t<-summary(aov(ms~beatL,data=tmp))
      T[k]<-t
    }
    
    
    
  }   
  
  
  return<-T  
  
}

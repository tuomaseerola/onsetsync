#' stats for asynchronies by pairs
#'
#' This function calculates simple t-test of the asynchronies of instruments (whether it differs from zero)
#'
#' @param df data frame to be processed
#' @param bybeat logical value whether beat information is used
#' @return Statistics output (Mean, Standard deviation, T-stat, P value)
#' @export

onsetsynch_by_pair_stats <-function(df,bybeat=FALSE){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  

  if(bybeat==FALSE){ # asynchronies
    m<-suppressMessages(reshape2::melt(df$asynch,variable.name='Instrument',value.name='ms'))
    m$ms<-m$ms*1000
    #colnames(m)<-c('Instrument','ms')
   # head(m)
    
    # check whether instrument is different from 0
    L<-levels(m$Instrument)
#    L
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
 #   print('by beat')
    m <- suppressMessages(reshape2::melt(df$asynch,variable.name='Instrument',value.name='ms'))
    m$ms<-m$ms*1000
#    colnames(m)<-c('Instrument','ms')
#    head(m)
    b<-suppressMessages(reshape2::melt(df$beatL))
    m$beatL<-b$value
 #   str(m)
    m$beatL<-factor(m$beatL)
    
    
    L<-levels(m$Instrument)
#    L
    T<-NULL
    for(k in 1:length(L)){
      #print(k)
      tmp<-dplyr::filter(m, Instrument==L[k])
      if(sum(is.na(tmp$ms))==nrow(tmp)){
        T$pval[k]<-NA
        T$tval[k]<-NA
      }
      
      if(sum(is.na(tmp$ms))<nrow(tmp)){
        t<-summary(aov(ms~beatL,data=tmp))
        T$pval[k]<-as.numeric(unlist(t)[9])
        T$tval[k]<-as.numeric(unlist(t)[7])
      }
    }
    
#    print(T)
    
  }   
  
  M=df$asynch %>% dplyr::summarise_all(funs(mean))
  SD=df$asynch %>% dplyr::summarise_all(funs(sd))
  T2 <- data.frame(M=t(M),SD=t(SD))
  T2$T<-T$tval
  T2$pval<-T$pval
  return<-T2  
  
}

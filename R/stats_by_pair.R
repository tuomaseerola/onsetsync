#' Calculate summary statistics for asynchronies by instrument pairs
#'
#' This function calculates simple t-test of the asynchronies of instruments (whether it differs from zero)
#'
#' @param df data frame to be processed
#' @param bybeat logical value whether beat information is used
#' @param adjust Adjust p values with Bonferroni correction (default)
#' @seealso \code{\link{sync_sample_paired}}, \code{\link{sync_execute_pairs}}
#' @return Statistics output (Mean, Standard deviation, T-stat, P value)
#' @import ggplot2
#' @import tidyr
#' @import magrittr
#' @import scales

stats_by_pair <-function(df,
                         bybeat=FALSE,
                         adjust='bonferroni'){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  
  Instrument <- summarise <- across <- NULL

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
  
#  M <- df$asynch %>% dplyr::summarise_all(funs(mean))
#  SD <- df$asynch %>% dplyr::summarise_all(funs(sd))
#  M <- df$asynch %>% dplyr::summarise(mean)
#  SD <- df$asynch %>% dplyr::summarise(sd)

  n<-names(df$asynch)
  M <- df$asynch %>% 
    summarise(across(n,mean))
  SD <- df$asynch %>% 
    summarise(across(n,sd))

  T2 <- data.frame(M=t(M),SD=t(SD))
  T2$T<-T$tval
  T2$pval<-T$pval
  
  ## Make the table look prettier
  T2$pval <- stats::p.adjust(T2$pval, method = adjust) # adjustment for multiple tests 
  T2$M <- T2$M * 1000                            # milliseconds
  T2$SD <- T2$SD * 1000                          # milliseconds
  T2$pval <- scales::pvalue(T2$pval)            # prettify
  
  return <- T2  
  
}

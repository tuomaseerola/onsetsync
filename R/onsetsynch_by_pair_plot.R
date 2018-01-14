#' plot synchronies by pairs
#'
#' This function plots the calculated asynchronies of instrument pairs.
#'
#' @param df data frame to be processed
#' @param bybeat Optional (FALSE by default) which addes the beats to the plot
#' @return Graphic output
#' @export

onsetsynch_by_pair_plot <-function(df,bybeat=FALSE){

  # T. Eerola, Durham University, IEMP project
  # 14/1/2018  
  
  
  if(bybeat==FALSE){ # asynchronies
  
  m<-reshape2::melt(df$asynch)
  m$value<-m$value*1000
  colnames(m)<-c('Instrument','ms')
  
  g1<-ggplot2::ggplot(m,aes(x=reorder(x=Instrument,-ms,mean),y=ms,fill=Instrument))+
    geom_violin(scale = "width",show.legend = FALSE,na.rm=TRUE)+
    geom_jitter(height = 0, width = 0.15,size=0.15,show.legend = FALSE,na.rm=TRUE)+
    geom_hline(yintercept = 0,color='red')+
    coord_flip()+
    theme_bw()
  g1

  }
  if(bybeat==TRUE){
    m<-reshape2::melt(df$asynch)
    m$value<-m$value*1000
    colnames(m)<-c('Instrument','ms')
    #head(m)
    b<-reshape2::melt(df$beatL)
    m$beatL<-b$value
    str(m)
    m$beatL<-factor(m$beatL)
    g1<-ggplot2::ggplot(m,aes(x=reorder(x=Instrument,-ms,mean),y=ms,fill=beatL))+
       geom_boxplot(outlier.shape = NA,varwidth = F,na.rm=TRUE)+
       coord_flip()+
      geom_hline(yintercept = 0,color='red')+
       theme_bw()
   g1
  }   

return<-g1  
  
}

#' Plot synchronies by instrument pairs
#'
#' This function plots the calculated asynchronies of instrument pairs.
#'
#' @param df data frame to be processed
#' @param bybeat Optional (FALSE by default) which adds the beats to the plot
#' @param reference Optional (0 by default) which adds the reference line to the plot
#' @seealso \code{\link{plot_by_variable}}
#' @return Graphic output
#' @import ggplot2
#' @import tidyr
#' @import magrittr

plot_by_pair <-function(df=NULL,
                        bybeat=FALSE,
                        reference=0){

  # T. Eerola, Durham University, IEMP project
  # 14/1/2018  
  Instrument <- ms <- beatL <- NULL
  
  if(bybeat==FALSE){ # asynchronies
  
  m <- suppressMessages(reshape2::melt(df$asynch,variable.name='Instrument',value.name='ms'))
  m$ms <- m$ms*1000
#  colnames(m)<-c('Instrument','ms')
  
  g1<-ggplot2::ggplot(m,ggplot2::aes(x=reorder(x=Instrument,-ms,mean),y=ms,fill=Instrument))+
    ggplot2::geom_violin(scale = "width",show.legend = FALSE,na.rm=TRUE)+
    ggplot2::geom_jitter(height = 0, width = 0.15,size=0.15,show.legend = FALSE,na.rm=TRUE)+
    ggplot2::geom_hline(yintercept = reference,color='red')+
    ggplot2::coord_flip()+
    ggplot2::xlab('Instrument pairs')+
    ggplot2::ylab('Synchrony (ms)')+
    ggplot2::theme_linedraw()
#  g1

  }
  if(bybeat==TRUE){
    m <- suppressMessages(reshape2::melt(df$asynch,variable.name='Instrument',value.name='ms'))
    m$ms<-m$ms*1000
    #colnames(m)<-c('Instrument','ms')
    #head(m)
    b<-suppressMessages(reshape2::melt(df$beatL))
    m$beatL<-b$value
    m$beatL<-factor(m$beatL)
    g1<-ggplot2::ggplot(m,ggplot2::aes(x=reorder(x=Instrument,-ms,mean),y=ms,fill=beatL))+
      ggplot2::geom_boxplot(outlier.shape = NA,varwidth = F,na.rm=TRUE)+
      ggplot2::coord_flip()+
      ggplot2::geom_hline(yintercept = reference,color='red')+
      ggplot2::xlab('Instrument pairs')+
      ggplot2::ylab('Synchrony (ms)')+
      ggplot2::theme_linedraw()
  }   

return <- g1  
  
}

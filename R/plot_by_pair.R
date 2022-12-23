#' Plot synchronies by instrument pairs
#'
#' This function plots the calculated asynchronies of instrument pairs.
#'
#' @param df data frame to be processed
#' @param bybeat Optional (FALSE by default) which adds the beats to the plot
#' @param reference Optional (0 by default) which adds the reference line to the plot
#' @param colourpalette Optional colour palette, Default 'PuOr' (Purple to Orange)
#' @seealso \code{\link{plot_by_variable}}
#' @return Graphic output
#' @import ggplot2
#' @import tidyr
#' @import magrittr

plot_by_pair <-function(df = NULL,
                        bybeat = FALSE,
                        reference = 0,
                        colourpalette = 'PuOr'){

  # T. Eerola, Durham University, IEMP project
  # 14/1/2018  
  Instrument <- ms <- beatL <- NULL
  
  palettetype <- 'qual'
  if(colourpalette=='Greys' | colourpalette=='Blues'){palettetype <- 'seq'}

  if(bybeat==FALSE){ # asynchronies
  
  m <- tidyr::pivot_longer(data=df$asynch,cols=c(1:dim(df$asynch)[2]),names_to = 'Instrument', values_to = 'ms')
  m$ms <- m$ms*1000

  g1 <- ggplot2::ggplot(m,ggplot2::aes(x=reorder(x=Instrument,-ms,mean),y=ms,fill=Instrument))+
    ggplot2::geom_violin(scale = "width",show.legend = FALSE,na.rm=TRUE,alpha=0.7)+
    ggplot2::geom_jitter(height = 0, width = 0.15,size=0.15,show.legend = FALSE,na.rm=TRUE,colour='grey50')+
    ggplot2::stat_summary(fun = "mean",
                 geom = "crossbar",
                 width = 0.4,
                 color = "black", show.legend = FALSE, na.rm=TRUE)+
    ggplot2::geom_hline(yintercept = reference,color='orange4',linetype='dashed')+
    ggplot2::scale_fill_brewer(palette = colourpalette,type = palettetype)+
    ggplot2::coord_flip()+
    ggplot2::xlab('Instrument pairs')+
    ggplot2::ylab('Synchrony (ms)')+
    ggplot2::theme_linedraw()
#  g1

  }
  if(bybeat==TRUE){
    #m <- suppressMessages(reshape2::melt(df$asynch,variable.name='Instrument',value.name='ms'))
    m <- tidyr::pivot_longer(data=df$asynch,cols=c(1:dim(df$asynch)[2]),names_to = 'Instrument', values_to = 'ms')
    
    m$ms<-m$ms*1000
    
    b <- tidyr::pivot_longer(data=df$beatL,cols=c(1:dim(df$beatL)[2]),names_to = 'variable', values_to = 'value')
    
    
    m$beatL <- b$value
    m$beatL <- factor(m$beatL)

    # Make sure there are sufficient number of colour palette categories for subdivs
    colpal <- RColorBrewer::brewer.pal(4,colourpalette)
    number_of_beats <- length(unique(m$beatL))
    colourpalette <- colorRampPalette(colpal)(number_of_beats)

    g1 <- ggplot2::ggplot(m,ggplot2::aes(x=reorder(x=Instrument,-ms,mean),y=ms,fill=beatL,label=beatL))+
      ggplot2::geom_boxplot(outlier.shape = NA,varwidth = F,na.rm=TRUE)+
      ggplot2::geom_hline(yintercept = reference,color='orange4',linetype='dashed')+
      ggplot2::scale_fill_manual(name='Subdiv.',values = colourpalette)+
      ggplot2::xlab('Instrument pairs')+
      ggplot2::ylab('Synchrony (ms)')+
      ggplot2::theme_linedraw()
  }   
  return <- g1  
}

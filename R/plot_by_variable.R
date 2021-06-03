#' Plots synchronies by any other structure
#'
#' \code{plot_by_variable} visualizes the 
#' calculated asynchronies of instruments across
#' another variable.
#'
#' @param df data frame to be processed
#' @param meta Variable information (Pair of instrument names, for instance)
#' @param xlab label for X axis
#' @return Graphic output
#' @seealso \code{\link{sync_sample_paired}} for synchronies between 
#' instruments, \code{\link{plot_by_beat}} for plotting.
#' @import ggplot2
#' @import tidyr
#' @import magrittr

plot_by_variable <-function(df,
                            meta='empty',
                            xlab='Tempo'){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  
  
  beatL <- asynch <- NULL
  
  DF<-data.frame(asynch=df$asynch,beatL=df$beatL)  
  
  g1 <- ggplot2::ggplot(DF, ggplot2::aes(beatL, asynch*1000)) + 
    ggplot2::geom_point(colour = "slateblue", size=2.5,na.rm=TRUE) + 
    ggplot2::geom_smooth(method="lm", colour='dark blue', formula=(y~x)) + 
    ggplot2::labs (title = meta, x = xlab, y = "Asynchrony (ms)", colour = "slateblue")+
    ggplot2::theme_linedraw()
  
  return <- g1  
}

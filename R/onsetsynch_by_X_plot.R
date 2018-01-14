#' plot synchronies by any other structure
#'
#' This function plots the calculated asynchronies of instruments across another variable
#'
#' @param df data frame to be processed
#' @param meta Variable information (Pair of instrument names, for instance)
#' @param xlab label for X axis
#' @return Graphic output
#' @export

onsetsynch_by_X_plot <-function(df,meta='empty',xlab='Tempo'){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  
  
  DF<-data.frame(asynch=df$asynch,beatL=df$beatL)  
  
  g1 <- ggplot2::ggplot(DF, aes(beatL, asynch*1000)) + 
    geom_point(colour = "slateblue", size=2.5) + 
    geom_smooth(method="lm", colour='dark blue', formula=(y~x)) + 
    labs (title = meta, x = xlab, y = "Asynchrony (ms)", colour = "slateblue")+
    theme_bw()
  
  return <- g1  
}

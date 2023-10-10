#' Plot synchronies by beat structures across datasets
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed (required)
#' @param asynchronies Variable name where the asynchronies are (required)
#' @param data Variable name where the beats are (required)
#' @param pcols Number of columns for multiple plots (default 1)
#' @param box Do the graphics by boxplot (optional)
#' @param colour colour for the boxplot (optional)
#' @param colorpalette colourpalette for the boxplot (optional)
#' @seealso \code{\link{plot_by_variable}}, \code{\link{plot_by_pair}}, \code{\link{plot_by_beat}}
#' @return Graphic output
#' @import ggplot2
#' @import tidyr
#' @import magrittr

plot_by_dataset <-
  function(df = NULL,
           asynchronies = NULL,
           data = NULL,
           pcols = 1,
           box = FALSE,
           colour = 'lightblue',
           colorpalette = 'Set2') {
    # T. Eerola, Durham University, IEMP project
    # 23/1/2018
    # needs work
    
    # for testing
    # df<-asere
    # instr<-c('Bass','Tres','Bell')
    # beat<-'SD'
    # virtual<-'Virtual.SD'
    # pcols<-2
    # box<-TRUE
    # griddeviations<-FALSE
    #print(data)
    #print(asynchronies)
    asynch <- n <- NULL
    
    DF <- dplyr::select(df, asynchronies, data)
    colnames(DF) <- c('asynch', 'data')
#    print(head(DF))
    
    g1 <-
      ggplot2::ggplot(DF, ggplot2::aes(asynch, fill = data), colour = 'black') +
      ggplot2::geom_density(alpha = 1, show.legend = FALSE) +
      ggplot2::scale_color_brewer(name = "Dataset",
                                  palette = colorpalette,
                                  type = "div") +
      ggplot2::facet_wrap( ~ data, pcols) +
      ggplot2::xlab(paste('Asynchrony (ms)')) +
      ggplot2::ylab('Density') +
      ggplot2::theme_linedraw()
    #g1
    
    if (box == TRUE) {

      # for N
        meds <- c(by(DF$asynch, DF$data, median))
        nlabels <- table(DF$data)
      
        g1 <- ggplot2::ggplot(DF, ggplot2::aes(data,asynch,fill=data)) +
        ggplot2::geom_violin(show.legend = FALSE) +
        ggplot2::stat_summary(fun=median, geom="crossbar", size=.3, color="black",show.legend = FALSE)+
        ggplot2::geom_text(data = data.frame(), ggplot2::aes(x = names(meds) , y = meds + 2, 
                                             label = paste0("n=", nlabels)), hjust = 0, size = 3)+
                  # ggplot2::scale_color_brewer(name = "Dataset",
        #                             palette = 'Set1',
        #                             type = "div") +
        ggplot2::scale_fill_brewer(palette = colorpalette) +
        ggplot2::xlab('Performance') +
        ggplot2::ylab('Asynchrony (ms)') +
        ggplot2::coord_flip()+
        # ggplot2::annotate(
        #   "text",
        #   x = as.numeric(DF$data),
        #   y = m$m + m$m * 0.0,
        #   label = paste("N=", m$count, sep = ""),
        #   size = 5
        # ) +
        ggplot2::theme_linedraw()
      #g1
    }
    return <- g1
  }

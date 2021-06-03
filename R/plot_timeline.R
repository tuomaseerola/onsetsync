#' Plot onsets across time for instruments.
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param data data frame to be processed
#' @param instr Instrument name to be processed
#' @param Ampl Amplitude of the onsets (optional)
#' @param Grouping Grouping factor (optional)
#' @seealso \code{\link{plot_by_variable}}
#' @return Graphic output
#' @export
#' @import ggplot2

# T. Eerola, Durham University, IEMP project
# 22/4/2021

plot_timeline <-
  function(data = NULL,
           instr = NULL,
           Ampl = NULL,
           Grouping = NULL) {
    
    
    ## debug start
    #data <- CSS_Song2
    #instr <- 'Tres'
    #Ampl <- NULL
    #Grouping <- 'Cycle'
    ## debug end  
    
    
    if (is.null(Ampl)) {
      data$Ampl <- 1
    }
    if (is.null(Grouping)) {
      data$Grouping <- 1
    }
    
      
    Onset <- NULL
    showlegend <- TRUE
    DF <- NULL
  #str(data)
    if(!is.null(Grouping)){
      for (k in 1:length(instr)) {
        tmp <- dplyr::select(dplyr::ungroup(data), c(instr[k], Ampl, dplyr::all_of(Grouping)))
        colnames(tmp)[1] <- 'Onset'
        colnames(tmp)[2] <- 'Ampl'
        colnames(tmp)[3] <- 'Grouping'
        tmp$instr <- instr[k]
        DF <- rbind(DF, tmp)
      }
      DF$Grouping <- factor(DF$Grouping)

      # if more than 16 levels, remove factors
      Grouping_Length <- length(levels(DF$Grouping))
      Grouping_Length
      if(Grouping_Length > 16){
        DF$Grouping <- as.integer(DF$Grouping)
        showlegend <- FALSE
        print('Over 16 levels, converting to integers')
        }
    }
    
    if(is.null(Grouping)){
      for (k in 1:length(instr)) {
        tmp <- dplyr::select(dplyr::ungroup(data), c(instr[k], Ampl))
        colnames(tmp)[1] <- 'Onset'
        colnames(tmp)[2] <- 'Ampl'
        #colnames(tmp)[3] <- 'Grouping'
        tmp$instr <- instr[k]
        DF <- rbind(DF, tmp)
      }
      showlegend <- FALSE
      DF$Grouping <- 1 # insert empty
    }
    #head(DF)
  #  showlegend
    DF$instr <- factor(DF$instr)
    DF <- tidyr::drop_na(DF)

    
  #DF$Grouping<-factor(DF$Grouping)

    fig <-
      ggplot2::ggplot(DF, ggplot2::aes(
        x = Onset,
        y = Ampl,
        colour = Grouping
      )) +
      ggplot2::geom_point(shape=21,fill='white',show.legend = showlegend) +
      ggplot2::geom_segment(ggplot2::aes(
        x = Onset,
        y = Ampl,
        xend = Onset,
        yend = 0
      ),show.legend = showlegend) +
    #  ggplot2::scale_colour_brewer(name = Grouping) +
      ggplot2::facet_wrap(. ~ instr, ncol = 1) +
      ggplot2::scale_x_time() +
      ggplot2::ylab('Ampl.') +
      ggplot2::xlab('Time (s)') +
      ggplot2::theme_linedraw()
    
    return <- fig
  }

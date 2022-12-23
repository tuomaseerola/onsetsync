#' Plot onsets across time for instruments.
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param data data frame to be processed
#' @param instr Instrument name to be processed
#' @param ampl Amplitude of the onsets (optional)
#' @param grouping Grouping factor (optional)
#' @seealso \code{\link{plot_by_variable}}
#' @return Graphic output
#' @export
#' @import ggplot2
#' @import hms

# T. Eerola, Durham University, IEMP project
# 22/4/2021

plot_timeline <-
  function(data = NULL,
           instr = NULL,
           ampl = NULL,
           grouping = NULL) {
    
    
    if (is.null(ampl)) {
      data$ampl <- 1
    }
    if (is.null(grouping)) {
      data$grouping <- 1
    }
    
      
    onset <- NULL
    showlegend <- TRUE
    DF <- NULL
  #str(data)
    if(!is.null(grouping)){
      for (k in 1:length(instr)) {
        tmp <- dplyr::select(dplyr::ungroup(data), c(instr[k], ampl, dplyr::all_of(grouping)))
        colnames(tmp)[1] <- 'onset'
        colnames(tmp)[2] <- 'ampl'
        colnames(tmp)[3] <- 'grouping'
        tmp$instr <- instr[k]
        DF <- rbind(DF, tmp)
      }
      DF$grouping <- factor(DF$grouping)

      # if more than 16 levels, remove factors
      grouping_length <- length(levels(DF$grouping))
      
      if(grouping_length > 16){
        DF$grouping <- as.integer(DF$grouping)
        showlegend <- FALSE
        print('Over 16 levels, converting to integers')
        }
    }
    
    if(is.null(grouping)){
      for (k in 1:length(instr)) {
        tmp <- dplyr::select(dplyr::ungroup(data), c(instr[k], ampl))
        colnames(tmp)[1] <- 'onset'
        colnames(tmp)[2] <- 'ampl'
        #colnames(tmp)[3] <- 'Grouping'
        tmp$instr <- instr[k]
        DF <- rbind(DF, tmp)
      }
      showlegend <- FALSE
      DF$grouping <- 1 # insert empty
    }
    #head(DF)
  #  showlegend
    DF$instr <- factor(DF$instr)
    DF <- tidyr::drop_na(DF)

    
  #DF$Grouping<-factor(DF$Grouping)

    fig <-
      ggplot2::ggplot(DF, ggplot2::aes(
        x = onset,
        y = ampl,
        colour = grouping
      )) +
      ggplot2::geom_point(shape=21,fill='white',show.legend = showlegend) +
      ggplot2::geom_segment(ggplot2::aes(
        x = onset,
        y = ampl,
        xend = onset,
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

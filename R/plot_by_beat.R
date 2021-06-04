#' Plot synchronies by beat structures
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed
#' @param instr Instrument name to be processed
#' @param beat Variable name where the beats are
#' @param virtual Variable name where the virtual beats are
#' @param pcols Number of columns for multiple plots 
#' @param griddeviations Add deviation from the virtual beats in 
#' @param boxplot Do the graphics by boxplot
#' @param colour colour for the boxplot
#' @return Graphic output
#' @import ggplot2
#' @import dplyr
#' @import hms

plot_by_beat <-
  function(df = NULL,
           instr = NULL,
           beat = NULL,
           virtual = NULL,
           pcols = 1,
           griddeviations = FALSE,
           boxplot = FALSE,
           colour = 'lightblue') {
    # T. Eerola, Durham University, IEMP project
    # 23/1/2018
    # needs work
    
#### DEBUG ----------------------------------------
   # print('debugging')
   # df <- asere
   # instr <- c('Bass','Clave')
   # beat <- 'SD'
   # virtual <- 'Virtual.SD'
   # pcols <- 2
   # griddeviations = FALSE
   # boxplot = FALSE
   # colour = 'lightblue'

#### FOR EACH INSTRUMENT, CALCULATE DEVIATION AND CREATE MATRIX -------------------
    
    VSD <- group_by <- beatF <- summarise <- VSDR <- name <- label <- NULL
    
    DF <- NULL
    tmp <- NULL
    S <- NULL
    s <- NULL
    #print(instr)
    for (k in 1:length(instr)) {
    #  print(instr[k])
      tmp <- dplyr::select(df, c(instr[k], dplyr::all_of(beat), dplyr::all_of(virtual)))
      #  head(tmp)
      colnames(tmp) <- c('instr', 'beat', 'virtual')
      tmp <-
        dplyr::mutate(tmp, VSD = instr - virtual)  # absolute time difference
      tmp <-
        dplyr::mutate(tmp, VSDR = VSD / (virtual - dplyr::lag(virtual)))  # proportion of interbeat
      tmp$name <- instr[k]
      DF <- rbind(DF, tmp)
      # extra labelling
      tmp$beatF <- factor(tmp$beat)
    #  print(str(tmp))
#      s <- dplyr::summarise(dplyr::group_by(tmp, beatF), M = mean(VSDR * 100, na.rm = TRUE))
      s <- tmp %>%
        group_by(beatF) %>%
        summarise(M = mean(VSDR, na.rm = TRUE)*100)

      s$Time <- min(DF$instr, na.rm = TRUE)
      s$name <- unique(tmp$name)
      S <- rbind(S, s)
    }
    
    DF$name <- factor(DF$name) # TURN names INTO A FACTOR
    S$name <- factor(S$name) # TURN names INTO A FACTOR
    
    DF <- tidyr::drop_na(DF)
    
    ## PLOT
    if (griddeviations == FALSE) {
      #  print('false...')
      g1 <- ggplot2::ggplot(DF, ggplot2::aes(
        x = (beat + VSDR),
        y = instr,
        colour = name
      )) +
        ggplot2::geom_point(size = 1, na.rm = TRUE,show.legend = FALSE,alpha=0.85) +
        ggplot2::scale_x_continuous(breaks = seq(1, max(DF$beat))) +
        ggplot2::scale_color_brewer(name = "Instrument",
                           palette = 'Set1',
                           type = "div") +
        ggplot2::facet_wrap( ~ name, ncol = pcols) +
        ggplot2::xlab(paste('Beat (', beat, ')', sep = '')) +
        ggplot2::scale_y_time()+
        ggplot2::ylab('Time (s)') +
        ggplot2::theme_linedraw()
      g1
    }
    
    ## PLOT with metrical grid deviations
    if (griddeviations == TRUE) {
      S$label <- paste(round(S$M, digits = 0), '%', sep = '')
      S$beat <- as.integer(S$beatF)
      
      
      g1 <- ggplot2::ggplot(DF, ggplot2::aes(
        x = (beat + VSDR),
        y = instr,
        colour = name
      )) +
        ggplot2::geom_point(size = 1, na.rm = TRUE,show.legend = FALSE,alpha=0.85) +
        ggplot2::scale_x_continuous(breaks = seq(1, max(DF$beat))) +
        ggplot2::scale_color_brewer(name = "Instr.",
                           palette = 'Set1',
                           type = "div") + # was Spectral
        ggplot2::facet_wrap( ~ name, ncol = pcols) +
        ggplot2::xlab(paste('Beat (', beat, ')', sep = '')) +
        ggplot2::ylab('Time (s)') +
        ggplot2::scale_y_time()+
        ggplot2::theme_linedraw()+
        ggplot2::geom_text(
          data    = S,
          mapping = ggplot2::aes(x = beat, y = 5, label = label),
          hjust   = 0.5,
          size = 2.5,
          angle = 0,
          color = "black",
          vjust   = -1
        )
      
    #  g1
      
    }
    
    if (boxplot == TRUE) {
      DF$beatF <- factor(DF$beat)
      
      g1 <- ggplot2::ggplot(DF, ggplot2::aes(x = (beatF), y = VSD * 1000)) +
        ggplot2::geom_boxplot(
          na.rm = TRUE,
          outlier.colour = "gray80",
          outlier.size = 0.25,
          fill = colour
        ) +
        ggplot2::scale_x_discrete(breaks = seq(1, max(DF$beat))) +
        ggplot2::facet_wrap( ~ name, ncol = pcols) +
        ggplot2::xlab(paste('Beat (', beat, ')', sep = '')) +
        ggplot2::ylab('Asynchrony (ms)') +
        ggplot2::theme_linedraw()
      #  g1
    }
    
    return <- g1
  }

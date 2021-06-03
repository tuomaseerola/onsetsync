#' Summarise onsets for instruments specified
#'
#' \code{summarise_onsets} is a function that
#' summarises the time difference between successive onsets
#' across instruments.
#'
#' @param df data frame to be processed
#' @param instr Instrument names to be processed
#' @param filter_lower Lower limit for onset differences to be summarised
#' @param filter_upper Upper limit for onset differences to be summarised
#' @param binw bin width for histogram
#' @param plot Option for plotting (FALSE default)
#' @return Output contain summarises of the onset differences
#' @import ggplot2
#' @import tidyr
#' @import magrittr
#' @import dplyr

# T. Eerola, Durham University, IEMP project
# 28/5/2021

summarise_onsets <- function(df = NULL,
                             instr = NULL,
                             filter_lower = 0,
                             filter_upper = 2,
                             binw = 0.25,
                             plot = FALSE) {
  # Empty variables
  instrument <- ungroup <- time.diff <- d <- NULL
  SUMMARY <- matrix(0, length(instr), 6)
  HIS <- NULL
  
  # loop across instruments
  for (k in 1:length(instr)) {
    #  print(instr[k])
    tmp <- dplyr::select(df, c(instr[k]))
    colnames(tmp)[1] <- 'instrument'
    
    h <-  tmp %>%
      ungroup %>%
      dplyr::select(instrument) %>%
      tidyr::drop_na() %>%
      dplyr::mutate(time.diff = instrument - dplyr::lag(instrument))
    
    h <-
      dplyr::filter(h, time.diff >= filter_lower &
                      time.diff <= filter_upper)
    HIS <-
      rbind(HIS, data.frame(d = h$time.diff, Instrument = instr[k]))
    
    SUMMARY[k,] <- c(
      length(h$time.diff),
      median(h$time.diff) * 1000,
      mean(h$time.diff) * 1000,
      sd(h$time.diff) * 1000,
      min(h$time.diff) * 1000,
      max(h$time.diff * 1000)
    )
    colnames(SUMMARY) <- c('N', 'Md', 'M', 'SD', 'Min', 'Max')
    rownames(SUMMARY) <- instr
  }
  
  
  if (plot == TRUE) {
    g <- ggplot2::ggplot(HIS, ggplot2::aes(d * 1000)) +
      ggplot2::geom_histogram(binwidth = binw * 1000,
                              fill = 'white',
                              colour = 'black') +
      ggplot2::xlab('Onset time difference in ms') +
      ggplot2::ylab('Count') +
      ggplot2::scale_x_continuous(limits = c(filter_lower * 1000, filter_upper * 1000)) +
      ggplot2::facet_wrap(. ~ Instrument, scales = "free") +
      ggplot2::theme_linedraw()
    suppressWarnings(print(g))
  }
  
  return <- SUMMARY
  
}

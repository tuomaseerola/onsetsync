#' Create a continuous vector of onsets with a sampling in Hz
#'
#' This is a conversion function that turns onsets into sampled time-series.
#'
#' @param data Data frame to be processed with discrete time points (onsets)
#' @param sr Sampling rate (default 500 Hz)
#' @param wlen Window length of percentage of the sr (default 4%)
#' @param plot If a plot is needed
#' @param time Time samples to be included in the output
#' @return Output contain vector of onset times
#' @import signal
#' @import ggplot2
#' @import tidyr

gaussify_onsets <- function(data = NULL,
                                 sr = 500,
                                 wlen = 0.04,
                                 plot = FALSE,
                                 time = TRUE) {
  onsetcurve <- NULL
  X <- Y <- NULL
  # remove NAs
  data <- data[!is.na(data)]
  
  # define time
  mintime <- min(data)
  maxtime <- max(data)
  t <- seq(mintime, (maxtime + 0 / sr), by = 1 / sr) # Time
  signal <- rep(0, 1, length(t))          # Empty vector
  
  # add 1 to locations of onsets
  signal[round((data - mintime) * sr) + 1] <- 1
  #  sometimes odd and even lengths of the signal result in different length t and signal
  # fix it by adding one frame to the end of t
  N <- length(signal) - length(t)
  if (N == 1) {
    t <- c(t, t[length(t)] + 1 / sr)
  }
  
  # define the window length
  WLEN <- round(sr * wlen)
  
  # add empty padding around time derived from WLEN
  signal <- c(array(0, WLEN), signal, array(0, WLEN))
  #minbuffer <- seq(mintime - WLEN / sr, mintime - 1 / sr, by = 1 / sr)
  #maxbuffer <- seq(maxtime + 2 / sr, maxtime + WLEN+1 / sr, by = 1 / sr)
  
  minbuffer <- array(NA, WLEN)
  maxbuffer <- array(NA, WLEN)
  
  t <- c(minbuffer, t, maxbuffer)
  
  # gaussify with hanning filter
  fil <- signal::hanning(n = WLEN)
  signalf <- signal::filter(filt = fil, a = 1, x = signal)
  st <- (WLEN * 1) + 1  #
  signalf_crop <- signalf[(st + round(WLEN / 2)):length(signalf)]
  t_crop <- t[(st + 1):(length(t) + 1 - round(WLEN / 2))]
  
  # put time and signal into a data.frame
  signalf_crop_time <-
    data.frame(time = t_crop, onsetcurve = signalf_crop)
  signalf_crop_time <- tidyr::drop_na(signalf_crop_time)
  
  # plot
  if (plot == TRUE) {
    g1 <-
      ggplot2::ggplot(signalf_crop_time, ggplot2::aes(x = time, y = onsetcurve)) +
      ggplot2::geom_line(colour = 'navyblue') +
      ggplot2::scale_x_time() +
      ggplot2::scale_y_continuous(limits = c(0, 1), expand = c(0.001, 0.001)) +
      ggplot2::geom_vline(xintercept = data, colour = 'red') +
      ggplot2::geom_point(data.frame(X = data, Y = 1),
                          mapping = ggplot2::aes(x = X, y = Y),
                          colour = 'red') +
      ggplot2::xlab('Time') +
      ggplot2::ylab('Onset Density') +
      ggplot2::theme_linedraw()
    output <- list(signal = signalf_crop_time, fig = g1)
  }
  
  
  # if only signal is needed
  if (time == FALSE) {
#    signalf_crop_time <- signalf_crop
    output <- signalf_crop
  }
 
  if (plot == TRUE) {
    return <- output
  } else {
    return <- signalf_crop_time
  }
  
#  if (plot == FALSE) {
  #  return <- signalf_crop_time
#    return <- output$signalf_crop_time
#  }
}
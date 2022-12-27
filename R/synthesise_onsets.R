#' Synthesise onsets with noises and clicks
#'
#' Take the specified instruments and create wave file with sounds where the onsets are
#'
#' @param data data frame to be processed
#' @param instruments Instruments names to be included
#' @param sr sampling rate (default 22050)
#' @param dur duration of sounds (default 30 ms)
#' @param type type of sounds (default noise, try click or synth from seewave)
#' @param freq freq of sounds (if synth is given as input)
#' @import seewave
#' @return wave file
#' @export

synthesise_onsets <-
  function(data = NULL,
           instruments  = NULL,
           sr = 22050,
           dur = 0.03,
           type = 'noise',
           freq = 2500) {
    WAVE <- NULL
    # T.E. 25/12/2022
    
    # # # # DEBUG
    #  data<-data.frame(Guitar=c(0.1,0.3,0.5,0.7),Bass=c(0.0,NA,0.5,1.0))
    #  instruments<-c('Guitar','Bass')
    #  sr <- 22050
    #  dur <- 0.1
    #  type<-'click'
    # # # # DEBUG

noisew <- NULL

    # define a function to be used when merging different instrument onsets        
    absmax <- function(x) {
      x[which.max(abs(x))]
    }
    
    # if less type parameters, create as many as instruments
    input_nro <- length(instruments) - length(type)
    if (input_nro != 0) {
      type <- rep(type[1], length(instruments))
    }
    
    ## arbitrary pitches
    FR <- seq(200, 2000, by = 40)
    if (is.null(freq) == TRUE) {
      freq <- FR[1:length(instruments)]
    }
    
    # trim data only to instruments specified
    data <- dplyr::select(data,dplyr::all_of(instruments))

    # create a vector for the whole track
    maxdur <- max(data, na.rm = T) + dur
#    print(paste("maxdur:",maxdur))
#    print(paste("fs:",sr))
#    print(paste("tracks:",length(instruments)))
    #  WAVE <- rep(0, maxdur * fs) # WAVE for each instrument
    WAVE <-
      matrix(0, (maxdur * sr), length(instruments)) # WAVE for each instrument
    # Loop across instruments
    for (k in 1:length(instruments)) {
   #    print(paste("instrument:",instruments[k]))
  #     print(paste("type:",type[k]))
      # part 1: sound type
      type0 <- type[k]
      
      if (type0 == 'click') {
        dbefore <- 1 / sr
        dpulse <- 4 / sr
        dafter <- dur - dbefore - dpulse
        p <-
          seewave::pulsew(
            dbefore = dbefore,
            dpulse = dpulse,
            dafter = dafter,
            f = sr,
            plot = FALSE,
            output = "matrix"
          )
        #     print(paste('click len:',length(p)))
      }
      # alternative (frequency)
      if (type0 == 'synth') {
        p <-
          seewave::synth(
            f = sr,
            d = dur,
            cf = freq[k],
            a = 1,
            signal = "tria",
            output = "matrix",
            shape = 'decr'
          )
      }
      
      if (type0 == 'noise') {
        p <- seewave::noisew(
          f = sr,
          d = dur,
          type = "unif",
          output = "matrix"
        )
      }
      if (is.numeric(type0) == TRUE) {
        # if frequency (Hz) is given as a param
        p <-
          seewave::synth(
            f = sr,
            d = dur,
            cf = type0,
            a = 1,
            signal = "saw",
            output = "matrix",
            shape = 'decr'
          )
      }
      
      # part 2: wave
      W <- rep(0, maxdur * sr) # WAVE for each instrument
      onsets <- data[, which(instruments[k] == names(data))]
      onsets <- onsets[!is.na(onsets)] # remove NAs
      for (i in 1:length(onsets)) {
        ind <- onsets[i] * sr
        W[(ind + 1):(ind + 1 + length(p) - 1)] <- p
      }
      #    WAVE <- WAVE + W
      W <- W[1:dim(WAVE)[1]]
      WAVE[, k] <- W
      WAVE_max <-
        apply(WAVE, MARGIN = c(1), absmax) # take the max amplitude
    }
    return <- WAVE_max
  }

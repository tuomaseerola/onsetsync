#' Estimate the periodicity of the onsets by a specific method
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed  (required)
#' @param instr Instrument name to be processed  (required)
#' @param method Periodicity analysis method: per (default), diff, acf, or fft
#' @param sampling_rate Sampling rate (Hz), default 500 Hz
#' @param freq_range Frequency range to be included in the periodicity analysis (in seconds), default 0 to 2
#' @param resolution Resolution for some of the analyses (in seconds), default 0.01
#' @param colour Line colour for plotting (optional)
#' @param title Title for plotting (optional)
#' @seealso \code{\link{summarise_periodicity}}
#' @return Graphic output
#' @export
#' @import ggplot2
#' @import tidyr
#' @import seewave
#' @seealso \code{\link{summarise_periodicity}} for summary function.

periodicity <-
  function(df = NULL,
           instr = NULL,
           method = 'per',
           sampling_rate = 500,
           freq_range = c(0, 2),
           resolution = 0.01,
           colour = 'navyblue',
           title = NULL) {
    # T. Eerola, Durham University, IEMP project
    # 22/4/2021
    
    ## FOR EACH INSTRUMENT, CALCULATE DEVIATION AND CREATE MATRIX
    
    # If no title is given, use the data frame name...
    
    if (is.null(title)) {
      title = deparse(substitute(df))
    }
    
    ## DEBUG
    # df <- CSS_Song2
    # instr <- 'Bass'
    # method <- 'fft'
    # sampling_rate <- 250
    # freq_range <- c(0, 2)
    # resolution <- 0.01
    # ignore_period_under <- 0.2
    # colour <- 'navyblue'
    
    onset <- Diff <- Ampl <- Time <- NULL
    
    tmp <- dplyr::select(df, tidyr::all_of(instr)) # added all_of
    colnames(tmp) <- 'onset'
    tmp <- tidyr::drop_na(tmp)    # drop NAs
    
    #### ONSET DIFF HISTOGRAM ------------------------------------
    if (method == 'diff') {
      tmp <- dplyr::mutate(tmp, Diff = c(NA, diff(onset)))
      tmp <-
        dplyr::filter(tmp, Diff >= freq_range[1] &
                        Diff <= freq_range[2])
      # estimate density via histogram
      h <-
        hist(
          tmp$Diff,
          breaks = seq(freq_range[1], freq_range[2], by = resolution),
          plot = FALSE
        )
      Per <- data.frame(Time = h$mids, Ampl = h$density)
      #H$density<-H$density/max(H$density)  # normalise
      
      # if(is.null(forced_max_ampl)){
      #  forced_max_ampl <- NA
      #  }
      #
      fig <-
        ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl / max(Ampl))) +
        ggplot2::geom_line(colour = colour) +
        ggplot2::xlab('Time (s)') +
        ggplot2::ylab('Normalised Ampl.') +
        ggplot2::scale_x_continuous(
          limits = c(freq_range[1], freq_range[2]),
          breaks = seq(freq_range[1], freq_range[2], by = 0.2)
        ) +
        ggplot2::ggtitle(title) +
        ggplot2::theme_linedraw() +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    #### AUTOCORRELATION ------------------------------------
    if (method == 'acf') {
      tmp_g <-
        gaussify_onsets(tmp$onset,
                             sr = sampling_rate,
                             time = TRUE,
                             wlen = 0.04,
                             plot = FALSE)
      
      if (tmp_g$onsetcurve[1] == 0) {
        # remove any leading zeros
        i <- tmp_g$onsetcurve == 0
        d <- which(diff(which(i)) != 1)
        tmp_g <- tmp_g[d[1]:nrow(tmp_g), ]
      }
      AC <-
        stats::acf(tmp_g$onsetcurve,
                   plot = FALSE,
                   lag.max = sampling_rate * freq_range[2])
      Per <- data.frame(Ampl = AC$acf / sampling_rate,
                        Time = (AC$lag + 1) / sampling_rate)
      #ggplot(Per,aes(Time,Ampl))+ geom_line(colour='blue')+ theme_light()
      # filter zero lag or close
      Per <-
        dplyr::filter(Per, Time >= freq_range[1] & Time <= freq_range[2])
      
      fig <-
        ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl / max(Ampl))) +
        ggplot2::geom_line(colour = colour) +
        ggplot2::xlab('Time (s)') +
        ggplot2::ylab('Normalised Ampl.') +
        ggplot2::scale_x_continuous(
          limits = c(freq_range[1], freq_range[2]),
          breaks = seq(freq_range[1], freq_range[2], by = 0.2)
        ) +
        ggplot2::ggtitle(title) +
        ggplot2::theme_linedraw() +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    #### FAST FOURIER TRANSFORM ------------------------------------
    if (method == 'fft') {
      tmp_g <-
        gaussify_onsets(tmp$onset,
                             sr = sampling_rate,
                             time = TRUE,
                             wlen = 0.04,
                             plot = FALSE)
      #      plot(tmp_g$time[400:800],tmp_g$onsetcurve[400:800],type='l')
      if (tmp_g$onsetcurve[1] == 0) {
        # remove any leading zeros
        i <- tmp_g$onsetcurve == 0
        d <- which(diff(which(i)) != 1)
        tmp_g <- tmp_g[d[1]:nrow(tmp_g), ]
      }
      #tmp_g$onsetcurve
      ### revised using seewave
      #      plot(tmp_g$time,tmp_g$onsetcurve,type = 'l',col='blue')
      Per <-
        seewave::spec(tmp_g$onsetcurve, f = sampling_rate, plot = FALSE) # ,flim = c(0.002,0.004)
      Per <- data.frame(Per)
      Per$x <-
        1 / (Per$x * 1000)#sampling_rate #   (KHz to Hz) #Added 1/ to fix an error! 19/6/2022
      colnames(Per) <- c('Time', 'Ampl')
      
      Per <-
        dplyr::filter(Per, Time >= freq_range[1] & Time <= freq_range[2])
      Per <- dplyr::filter(Per, Time != 'Inf')
      Per <- dplyr::arrange(Per, Time)
      
      fig <-
        ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl / max(Ampl))) +
        ggplot2::geom_line(colour = colour, na.rm = TRUE) +
        ggplot2::xlab('Time (s)') +
        ggplot2::ylab('Normalised Ampl.') +
        ggplot2::scale_x_continuous(
          limits = c(freq_range[1], freq_range[2]),
          breaks = seq(freq_range[1], freq_range[2], by = 0.2)
        ) +
        ggplot2::ggtitle(title) +
        ggplot2::theme_linedraw() +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    
    #### spectrum (periodigram using fft with smoothing) --------
    
    if (method == 'per') {
      tmp_g <-
        gaussify_onsets(tmp$onset,
                             sr = sampling_rate,
                             time = TRUE,
                             wlen = 0.04,
                             plot = FALSE)
      
      if (tmp_g$onsetcurve[1] == 0) {
        # remove any leading zeros
        i <- tmp_g$onsetcurve == 0
        d <- which(diff(which(i)) != 1)
        tmp_g <- tmp_g[d[1]:nrow(tmp_g), ]
      }
      #    plot(tmp_g$time,tmp_g$onsetcurve,type='l')
      spec <-
        spectrum(
          tmp_g$onsetcurve,
          log = "no",
          span = 2,
          plot = FALSE,
          demean = TRUE
        )
      spx <- spec$freq / (1 / sampling_rate)
      spy <- 2 * spec$spec
      #   plot(spy~spx,xlab="frequency",ylab="spectral density",type="l",xlim=c(0,5))
      #    dom.freq<-spx[which.max(spy)]
      #    dom.freq
      
      Per <- data.frame(Time = 1 / spx, Ampl = spy)
      
      fig <-
        ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl / max(Ampl))) +
        ggplot2::geom_line(colour = colour,na.rm = TRUE) +
        ggplot2::xlab('Time (s)') +
        ggplot2::ylab('Normalised Ampl.') +
        ggplot2::scale_x_continuous(
          limits = c(freq_range[1], freq_range[2]),
          breaks = seq(freq_range[1], freq_range[2], by = 0.2)
        ) +
        ggplot2::ggtitle(title) +
        ggplot2::theme_linedraw() +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    
    Per <-
      dplyr::filter(Per, Time >= freq_range[1] & Time <= freq_range[2])
    
    return <- list(Curve = Per, Figure = fig)
  }
#' Estimate the periodicity of the onsets by a specific method
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed
#' @param instr Instrument name to be processed
#' @param method Periodicity analysis method (diff, acf, fft, wavelet)
#' @param sampling_rate Sampling rate (Hz)
#' @param freq_range Frequency range to be included in the periodicity analysis (in seconds)
#' @param resolution Resolution for some of the analyses (in seconds)
#' @param ignore_acf_lower Ignore period lower than this (in seconds)
#' @param colour Line colour for plotting
#' @param title Title for plotting
#' @seealso \code{\link{periodicity_moments}}
#' @return Graphic output
#' @export
#' @import ggplot2
#' @import tidyr
#' @import WaveletComp
#' @seealso \code{\link{periodicity_moments}} for summary function.

periodicity <-
  function(df = NULL,
           instr = NULL,
           method = 'acf',
           sampling_rate = 250,
           freq_range = c(0, 2),
           resolution = 0.01,
           ignore_acf_lower = 0.2,
           colour = 'navyblue',
           title = NULL) {
    # T. Eerola, Durham University, IEMP project
    # 22/4/2021
    
    ## FOR EACH INSTRUMENT, CALCULATE DEVIATION AND CREATE MATRIX

    # If no title is given, use the data frame name...
        
    if(is.null(title)){
      title=deparse(substitute(df))
      }
    
    ## DEBUG
    # df <- CSS_Song2
    # instr <- 'Bass'
    # method <- 'acf'
    # sampling_rate <- 250
    # freq_range <- c(0, 2)
    # resolution <- 0.01
    # ignore_acf_lower <- 0.2
    # colour <- 'navyblue'
    
    onset <- Diff <- Ampl <- Time <- NULL
        
    tmp <- dplyr::select(df, instr)
    colnames(tmp) <- 'onset'
    
    #### ONSET DIFF HISTOGRAM ------------------------------------
    if (method == 'diff') {
      tmp <- dplyr::mutate(tmp, Diff = c(NA, diff(onset)))
      tmp <-
        dplyr::filter(tmp, Diff >= freq_range[1] & Diff <= freq_range[2])
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
      fig <- ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl)) +
        ggplot2::geom_line(colour=colour) +
        ggplot2::xlab('Time (s)') +
        ggplot2::scale_x_continuous(limits = c(freq_range[1], freq_range[2]),breaks=seq(freq_range[1],freq_range[2],by=0.2)) +
#        ggplot2::scale_y_continuous(limits = c(NA,forced_max_ampl))+
        ggplot2::ggtitle(title)+
        ggplot2::theme_linedraw()+
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    #### AUTOCORRELATION ------------------------------------
    if (method == 'acf') {
      tmp_g <- gaussify_onsets(tmp$onset, sr = sampling_rate,time = TRUE)
      
      if(tmp_g$onsetcurve[1]==0){ # remove any leading zeros
        i<-tmp_g$onsetcurve==0
        d<-which(diff(which(i))!=1)
        tmp_g <- tmp_g[d[1]:nrow(tmp_g),]
      }
      AC <- stats::acf(tmp_g$onsetcurve, plot = FALSE, lag.max = sampling_rate * freq_range[2])
      Per <- data.frame(Ampl = AC$acf / sampling_rate,
                   Time = AC$lag / sampling_rate)
      # filter zero lag or close
      Per <- dplyr::filter(Per, Time >= ignore_acf_lower)
      fig <- ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl)) +
        ggplot2::geom_line(colour=colour) +
        ggplot2::xlab('Time (s)') +
        ggplot2::scale_x_continuous(limits = c(freq_range[1], freq_range[2]),breaks=seq(freq_range[1],freq_range[2],by=0.2)) +
        #ggplot2::scale_y_continuous(limits = c(NA,forced_max_ampl))+
        ggplot2::ggtitle(title)+
        ggplot2::theme_linedraw()+
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    #### FAST FOURIER TRANSFORM ------------------------------------
    if (method == 'fft') {
      tmp_g <- gaussify_onsets(tmp$onset, sr = sampling_rate,time = TRUE)
      
      if(tmp_g$onsetcurve[1]==0){ # remove any leading zeros
        i<-tmp_g$onsetcurve==0
        d<-which(diff(which(i))!=1)
        tmp_g <- tmp_g[d[1]:nrow(tmp_g),]
      }
      
      x.spec <- stats::spectrum(tmp_g$onsetcurve,
                                log = "no",
                                span = 10,
                                plot = FALSE)
      spx <- x.spec$freq * sampling_rate
      spy <- 2 * x.spec$spec
      Per <- data.frame(Time = 1 / spx, Ampl = spy)
      
      fig <- ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl)) +
        ggplot2::geom_line(colour=colour) +
        ggplot2::xlab('Time (s)') +
        ggplot2::scale_x_continuous(limits = c(freq_range[1], freq_range[2]),breaks=seq(freq_range[1],freq_range[2],by=0.2)) +
        #ggplot2::scale_y_continuous(limits = c(NA,forced_max_ampl))+
        ggplot2::ggtitle(title)+
        ggplot2::theme_linedraw()+
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    }
    
    #### WAVELET ------------------------------------
    if (method == 'wavelet') {
      tmp_g <- gaussify_onsets(tmp$onset, sr = sampling_rate,time = TRUE)
      
      if(tmp_g$onsetcurve[1]==0){ # remove any leading zeros
        i<-tmp_g$onsetcurve==0
        d<-which(diff(which(i))!=1)
        tmp_g <- tmp_g[d[1]:nrow(tmp_g),]
      }
      
      tmp2 <- data.frame(onsetdensity = tmp_g$onsetcurve)
      W <-
        WaveletComp::analyze.wavelet(
          tmp2,
          "onsetdensity",
          loess.span = 0,
          method = "Fourier.rand",
          dt = 1,
          dj = 1 / 50,
          lowerPeriod = sampling_rate / 25,
          upperPeriod = sampling_rate * freq_range[2],
          make.pval = FALSE,
          n.sim = 0,
          verbose = FALSE
        )
      Per <- data.frame(Time = W$Period / sampling_rate,
                        Ampl = W$Power.avg)
      
      fig <- ggplot2::ggplot(Per, ggplot2::aes(x = Time, y = Ampl)) +
        ggplot2::geom_line(colour=colour) +
        ggplot2::xlab('Time (s)') +
        ggplot2::scale_x_continuous(limits = c(freq_range[1], freq_range[2]),breaks=seq(freq_range[1],freq_range[2],by=0.2)) +
        #ggplot2::scale_y_continuous(limits = c(NA,forced_max_ampl))+
        ggplot2::ggtitle(title)+
        ggplot2::theme_linedraw()+
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
      
    }
    
    return <- list(Curve = Per, Figure = fig)
  }

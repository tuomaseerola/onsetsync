#' Summarise onset periodicities by calculating the moments (mean, etc.)
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param data data frame to be processed (required)
#' @param method method of choosing the peaks (max default, or first)
#' @return Graphic output
#' @seealso \code{\link{periodicity}}
#' @import moments
#' @export

summarise_periodicity <- function(data = NULL,
                                method = 'max') {
  # T. Eerola, Durham University, IEMP project
  # 22/4/2021
  P <- Ampl <- Time <- NULL
  # Extract moments

  find_peaks <- function (x, m = 3) {
    shape <- diff(sign(diff(x, na.pad = FALSE)))
    pks <- sapply(
      which(shape < 0),
      FUN = function(i) {
        z <- i - m + 1
        z <- ifelse(z > 0, z, 1)
        w <- i + m + 1
        w <- ifelse(w < length(x), w, length(x))
        if (all(x[c(z:i, (i + 2):w)] <= x[i + 1]))
          return(i + 1)
        else
          return(numeric(0))
      }
    )
    pks <- unlist(pks)
    pks
  }
  
  if (method == 'first') {
    Per_peaks <- data$Time[find_peaks(data$Ampl)]
    PerAmpl_peaks <- data$Ampl[find_peaks(data$Ampl)]
    Summary <-
      dplyr::summarise(
        data,
        Max = PerAmpl_peaks[1],
        Sum = sum(Ampl),
        Kurt = moments::kurtosis(Ampl),
        Skew = moments::skewness(Ampl),
        Per = Per_peaks[1]
      )
  }
  if (method == 'max') {
    Summary <-
      dplyr::summarise(
        data,
        Max = max(Ampl),
        Sum = sum(Ampl),
        Kurt = moments::kurtosis(Ampl),
        Skew = moments::skewness(Ampl),
        Per = Time[Ampl == max(Ampl)]
      )
  }
  return <- Summary
}

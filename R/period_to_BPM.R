#' Convert period in seconds to Beats Per Minute (BPM)
#'
#' Converts period in seconds to BPM
#'
#' @param period data frame to be processed
#' @param beats_per_minute baseline assumption of how many beats there are in min.
#' @seealso \code{\link{periodicity_moments}},\code{\link{periodicity}}
#' @return Numeric output
#' @export
#' @examples
#' bpm <- period_to_BPM(0.666)
#' print(bpm)

period_to_BPM <-
  function(period = NULL, 
           beats_per_minute = 60) {
    # T. Eerola, Durham University, IEMP project
    # 22/4/2021
    
    p <- 1 / period * beats_per_minute

    return <- p
  }

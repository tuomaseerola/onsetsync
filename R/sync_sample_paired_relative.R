#' Compare instrument onset times to mean onset times from several instruments
#'
#' @param df data frame to be processed (required)
#' @param instr Instrument name to be processed (required)
#' @param instr_ref Instrument reference names or reference timing to be processed (required)
#' @param beat Beat structure (subdivisions) to be included (required)
#' @seealso \code{\link{sync_execute_pairs}}
#' @return difference in ms 
#' @export

sync_sample_paired_relative <- function(df = NULL,
  instr = NULL,
  instr_ref = NULL, 
  beat = NULL){

  Isochronous.SD.Time <- NULL
  
  # T. Eerola, Durham University, IEMP project
  # 21/12/2022  

  df <- dplyr::select(df,-Isochronous.SD.Time)
  df <- add_isobeats(df = df, instr = instr_ref, beat = beat)

  # then compare onset times to this new reference
  df2 <- sync_sample_paired(df,instr1 = instr, instr2 = 'Mean.Time', beat = beat) # revised
  output <- summarise_sync(df2)
  return <- output 
}

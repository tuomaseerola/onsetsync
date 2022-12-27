#' Compare instrument onset times to mean onset times from several instruments
#'
#' @param df data frame to be processed
#' @param instr Instrument name to be processed
#' @param instr_ref Instrument reference names to be processed
#' @param beat Beat structure (subdivisions) to be included
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
  df2 <- sync_sample_paired(df,instr1 = instr, instr2 = 'Isochronous.SD.Time', beat = beat)
  output <- summarise_sync(df2)
  return <- output 
}

#' Determine the number of joint onsets for two instruments
#'
#' Calculate the number of joint onsets for two instruments
#'
#' @param df data frame to be processed
#' @param instr1 Instrument 1 name to be processed
#' @param instr2 Instrument 2 name to be processed
#' @seealso \code{\link{sync_execute_pairs}}
#' @return List containing asynchronies and beat structures
#' @export

sync_joint_onsets <- function(df = NULL,
                              instr1 = NULL,
                              instr2 = NULL) {
  # T. Eerola, Durham University, IEMP project
  # 23/12/2022
  
  ins1 <- as.matrix(df[, which(colnames(df) == instr1)])
  ins2 <- as.matrix(df[, which(colnames(df) == instr2)])
  ind <- !is.na(ins1) & !is.na(ins2)
  len_joint <- length(which(ind)) # 
  return <- len_joint
}

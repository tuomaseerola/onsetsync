#' Extract synchronies for specific corpora and instruments
#'
#' \code{onsetsynch_synchrony_across_corpora} takes 
#'  
#'
#' @param corpus corpora to be processed (contains filename, instruments, beats)
#' @return List containing asynchronies and beat structures
#' @seealso \code{\link{onsetsynch_sample_paired}}
#' @export

onsetsynch_synchrony_across_corpora <- function(corpus){

  filename <- corpus.filename
  
  # T. Eerola, Durham University, IEMP project
  # 24/1/2018  
  
  DebBh_Drut <- read.csv('../data/DebBh_Drut.csv')
  
  d2 <- onsetsynch_sample_paired(DebBh_Drut,'Tabla','Guitar',N=0,beat='Beat.pos')
  d2<-data.frame(d2);d2$dataset<-'DebBh_Drut'
  

  return<-list(x=x)
}

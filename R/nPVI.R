#' Measure of durational variability of events
#'
#' This function calculates of durational variability of events (nPVI).
#'
#' This measure is borne out of language research. It has been noted that 
#' the variability of vowel duration is greater in stress- vs. syllable-timed 
#' languages (Grabe & Low, 2002). This measure accounts for the 
#' variability of durations and is also called "normalized Pairwise Variability 
#' Index" (nPVI). Patel & Daniele have applied it to music (2003) by comparing
#' whether the prosody of different languages is also reflected in music. There is 
#' a clear difference between a sample of works by French and English composers.
#' 
#' @param df data frame to be processed
#' @param instr Instrument to be processed
#' @return integer value
#' @export
#' @import tidyr

nPVI <-
  function(df = NULL,
           instr = NULL) {
    # T. Eerola, Durham University, IEMP project
    # 25/6/2021
    
    
    tmp <- dplyr::select(df, instr)
    colnames(tmp) <- 'onset'
#    tmp<-data.frame(onset=c(0,0.2,0.4,0.6,0.8,1.0)) ## EVEN
#    tmp<-data.frame(onset=c(0,0.4,0.6,1.0,1.2,1.6)) ## variable
    tmp <- tidyr::drop_na(tmp)    # drop NAs
    dur <- diff(tmp$onset)
    
# from Miditoolbox ###################
#    a=dur(nmat,'sec');
#for i=2:length(a)
#  s(i)=(a(i-1)-a(i))/((a(i-1)+a(i))/2);
#end
#n = 100/(length(a)-1) * sum(abs(s));
########################################
  s <- NULL
  for (i in 2:length(dur)) {
    s[i-1] <- (dur[i-1]-dur[i])/((dur[i-1]+dur[i])/2);
  }
n = (100/(length(dur)-1)) * sum(abs(s))
    
    return <- n
  }

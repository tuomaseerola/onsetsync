#' Calculate summary statistics for asynchronies by instrument pairs
#'
#' This function calculates simple t-test of the asynchronies of instruments (whether they differ from zero)
#'
#' @param df data frame to be processed
#' @param bybeat logical value whether beat information is used
#' @param adjust Adjust p values with Bonferroni correction (default)
#' @seealso \code{\link{sync_sample_paired}}, \code{\link{sync_execute_pairs}}
#' @return Statistics output (Mean, Standard deviation, T-stat, P value)
#' @import ggplot2
#' @import tidyr
#' @import magrittr
#' @import scales

summarise_sync_by_pair <- function(df,
                                   bybeat = FALSE,
                                   adjust = 'bonferroni') {
  # T. Eerola, Durham University, IEMP project
  # 14/1/2018
  Instrument <- summarise <- across <- beatL <- Subdivision <- Asynchrony <- dn <- NULL
  
  if (bybeat == FALSE) {
    m <- tidyr::pivot_longer(data=df$asynch,cols=c(1:dim(df$asynch)[2]),names_to = 'Instrument', values_to = 'ms')
    m$ms <- m$ms * 1000
 #   print(head(m))
    # check whether instrument is different from 0
#    L <- levels(m$Instrument)
#    print(paste('Levels:',L))
    L <- unique(m$Instrument)
#    print(paste('Levels 2:',L))
    
    T <- NULL
    for (k in 1:length(L)) {
      tmp <- m$ms[m$Instrument == L[k]]
      if (sum(is.na(tmp)) < length(tmp)) {
        tt <- t.test(tmp, mu = 0)
        T$tval[k] <- as.numeric(tt$statistic)
        T$pval[k] <- as.numeric(tt$p.value)
      }
      if (sum(is.na(tmp)) == length(tmp)) {
        T$tval[k] <- NA
        T$pval[k] <- NA
      }
    }
    n <- names(df$asynch)
    M <- df$asynch %>%
      summarise(across(n, mean,na.rm=TRUE))
    SD <- df$asynch %>%
      summarise(across(n, sd,na.rm=TRUE))

    T2 <- data.frame(M = t(M), SD = t(SD))
    T2$T <- T$tval
    T2$pval <- T$pval
    ## Make the table look prettier
    T2$pval <-
      stats::p.adjust(T2$pval, method = adjust) # adjustment for multiple tests
    T2$M <- T2$M * 1000                            # milliseconds
    T2$SD <- T2$SD * 1000                          # milliseconds
    T2$pval <- scales::pvalue(T2$pval)            # prettify
  #  print(T2)
  }
  
  if (bybeat == TRUE) {
    # warn if attempted for multiple instruments!
    x <- dim(dn$asynch)
    if(!is.null(x)){
      print(ncol(dn$asynch))
      print('Warning: Apply bybeat option to 1 pair of instruments, not to multiple instruments')
      T2 <- NULL
    }
    else {
    m <- tidyr::pivot_longer(data=df$asynch,cols=c(1:dim(df$asynch)[2]),names_to = 'Instrument', values_to = 'ms')
    m$ms <- m$ms * 1000
    #print(head(m))
    b <- tidyr::pivot_longer(data=df$beatL,cols=c(1:dim(df$beatL)[2]),names_to = 'variable', values_to = 'value')
    m$beatL <- b$value
    m$beatL <- factor(m$beatL)
    subdivisions <- levels(m$beatL)
   # print(subdivisions)
    T <- NULL
    for (k in 1:length(subdivisions)) {
      #print(paste(k,'-',as.numeric(subdivisions[k])))
      tmp <- dplyr::filter(m, beatL == as.numeric(subdivisions[k]))
      if (nrow(tmp)==1) {
        T$pval[k] <- NA
        T$tval[k] <- NA
      }
      else if (sum(is.na(tmp$ms)) == nrow(tmp)) {
        T$pval[k] <- NA
        T$tval[k] <- NA
      }
      else if (sum(is.na(tmp$ms)) < nrow(tmp)) {
        tt <- t.test(tmp$ms, mu = 0)
        T$tval[k] <- as.numeric(tt$statistic)
        T$pval[k] <- as.numeric(tt$p.value)
      }
    }

    x <- data.frame(Asynchrony=m$ms,Subdivision=m$beatL)
    #print(head(x))
    T2 <-
      dplyr::summarise(
        dplyr::group_by(x,Subdivision),
        N = n(),
        M = mean(Asynchrony,na.rm=TRUE),
        SD = sd(Asynchrony,na.rm=TRUE)
      )
    #print(head(T2))
    T2$T <- T$tval
    T2$pval <- T$pval
    ## Make the table look prettier
    T2$pval <-
      stats::p.adjust(T2$pval, method = adjust) # adjustment for multiple tests
    T2$M <- T2$M #* 1000                            # milliseconds
    T2$SD <- T2$SD #* 1000                          # milliseconds
    T2$pval <- scales::pvalue(T2$pval)            # prettify
    }    
  }
  
  return <- data.frame(T2)
  
}

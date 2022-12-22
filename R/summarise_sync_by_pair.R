#' Calculate summary statistics for asynchronies by instrument pairs
#'
#' This function calculates simple t-test of the asynchronies of instruments (whether it differs from zero)
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
  Instrument <- summarise <- across <- beatL <- Subdivision <- Asynchrony <- NULL
  
  if (bybeat == FALSE) {
    # asynchronies
    # m <-
    #   suppressMessages(reshape2::melt(
    #     df$asynch,
    #     variable.name = 'Instrument',
    #     value.name = 'ms'
    #   ))
    m <- tidyr::pivot_longer(data=df$asynch,cols=c(1:dim(df$asynch)[2]),names_to = 'Instrument', values_to = 'ms')
    m$ms <- m$ms * 1000
    # check whether instrument is different from 0
    L <- levels(m$Instrument)
    #    L
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
      summarise(across(n, mean))
    SD <- df$asynch %>%
      summarise(across(n, sd))
    
    T2 <- data.frame(M = t(M), SD = t(SD))
    T2$T <- T$tval
    T2$pval <- T$pval
    ## Make the table look prettier
    T2$pval <-
      stats::p.adjust(T2$pval, method = adjust) # adjustment for multiple tests
    T2$M <- T2$M * 1000                            # milliseconds
    T2$SD <- T2$SD * 1000                          # milliseconds
    T2$pval <- scales::pvalue(T2$pval)            # prettify
  }
  
  
  if (bybeat == TRUE) {
    #  print('by beat')
    # m <-
    #   suppressMessages(reshape2::melt(
    #     df$asynch,
    #     variable.name = 'Instrument',
    #     value.name = 'ms'
    #   ))
    m <- tidyr::pivot_longer(data=df$asynch,cols=c(1:dim(df$asynch)[2]),names_to = 'Instrument', values_to = 'ms')
    
    m$ms <- m$ms * 1000
    b <- tidyr::pivot_longer(data=df$beatL,cols=c(1:dim(df$beatL)[2]),names_to = 'variable', values_to = 'value')
    m$beatL <- b$value
    m$beatL <- factor(m$beatL)
    subdivisions <- levels(m$beatL)
    T <- NULL
    for (k in 1:length(subdivisions)) {
      tmp <- dplyr::filter(m, beatL == as.numeric(subdivisions[k]))
      if (sum(is.na(tmp$ms)) == nrow(tmp)) {
        T$pval[k] <- NA
        T$tval[k] <- NA
      }
      if (sum(is.na(tmp$ms)) < nrow(tmp)) {
        tt <- t.test(tmp$ms, mu = 0)
        T$tval[k] <- as.numeric(tt$statistic)
        T$pval[k] <- as.numeric(tt$p.value)
      }
    }
    
    
    x <- data.frame(df)
    colnames(x) <- c('Asynchrony', 'Subdivision')
    
    
    T2 <-
      dplyr::summarise(
        dplyr::group_by(x,Subdivision),
        N = n(),
        M = mean(Asynchrony),
        SD = sd(Asynchrony)
      )
    T2$T <- T$tval
    T2$pval <- T$pval
    
    ## Make the table look prettier
    T2$pval <-
      stats::p.adjust(T2$pval, method = adjust) # adjustment for multiple tests
    T2$M <- T2$M * 1000                            # milliseconds
    T2$SD <- T2$SD * 1000                          # milliseconds
    T2$pval <- scales::pvalue(T2$pval)            # prettify
    
  }
  
  return <- T2
  
}

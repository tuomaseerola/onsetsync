#' add annotation such as the beat cycle starts to the onset data frame
#'
#' This function adds cycle start times from annotations to onsets
#'
#' @param df data frame to be processed (required)
#' @param annotation Annotation (cycle starts) to be added
#' @param time Annotated times of the cycle starts to be added
#' @param reference The target column (Label.SD) for cycles in IEMP data
#' @seealso \code{\link{add_isobeats}}
#' @return dataframe with added column of cycles and cycle onsets
#' @import dplyr

add_annotation <-
  function(df = NULL,
           annotation = NULL,
           time = NULL,
           reference = NULL) {
    # T. Eerola, Durham University, IEMP project
    # 18/5/2021
    # New function to integrate annotations of cycles with onsets

    if(reference=='Label.SD'){
      tmp <- df$Label.SD
      ind <- grep(pattern = ":1$|\\|1$", x=tmp) # gets the cycle beginnings (fixed to include | in June 2022)
      if(length(ind)!=length(annotation)){
        stop('Error:Cycle beginnings and the annotation cycle data are of different lengths!')
      }
#    df$Cycle<-NA
#    df$Cycle[ind]<-annotation
    df$CycleTime<-NA
    df$CycleTime[ind]<-time
    df$Cycle <- as.numeric(gsub(pattern = ":[0-9]+$|\\|[0-9]+$", replacement = '', x = tmp)) # converts the cycles into numeric, (fixed to include | in June 2022)
    }
    
    if(reference!='Label.SD'){
      stop('Error: reference is not "Label.SD". Other reference currently not available.')
    }
    
    return <- df
  }

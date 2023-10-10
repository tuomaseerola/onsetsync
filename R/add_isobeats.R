#' Add isochronous times or mean onset times to the data frame
#'
#' Given one instrument, this is the reference time which adds isochronous beats to a
#' onset dataframe based on beat levels and average onset of the 1st beat.
#' Given two or instruments, the mean onset time is added as a reference time.
#'
#' @param df data frame to be processed, where the minimal requirements are:
#' (1) a reference time OR two or more instruments (instr input) and (2)
#' beat sub-division (beat input)
#' @param instr required element that specifies how the reference time is constructed:
#' if given two or more instruments, will create timings based on mean onset times of the instruments.
#' if given one input as an argument, this is assumed to be an external cycle time and
#' the reference time is then inferred from beat sub-divisions, cycles and mean onset times 
#' of the first beat. Required input.
#' @param beat Beat sub-divisions (required)
#' @param beatlabel variable which labels the newly created beats (optional)
#' @seealso \code{\link{add_annotation}}
#' @return dataframe with added column of isochronous beats ("Iso.Time") OR mean onset times ("Mean.Time")
#' @import ggplot2
#' @import tidyr
#' @import magrittr

add_isobeats <- function(df = NULL,
                         instr = NULL,
                         beat = NULL,
                         beatlabel = 'Iso.Time'){ # was:'Isochronous.SD.Time'
  
  . = NULL
  # T. Eerola, Durham University, IEMP project
  # 22/1/2018  
  # Minor Fix 18/5/2021
  mean_onset <- all_of <- NULL
  
  # Mean onset times for the selected instruments
  if(length(instr)>1){ # revised
    DF <- df %>% dplyr::select(all_of(instr)) %>% dplyr::mutate(mean_onset=rowMeans(.,na.rm = TRUE))
    DF$mean_onset[DF$mean_onset=='NaN']<-NA
    #names(DF)[which(names(DF)=='mean_onset')]<-'Mean.Onset'
    DF<-cbind(df,Mean.Time=DF$mean_onset)
    if(beatlabel!='Iso.Time'){
      names(DF)[which(names(DF)=='Mean.Time')] <- beatlabel
    }
#    return <- DF
  }
  
  if(length(instr)==1){ # for isochrony from cycles and beats
    beat_N <- max(as.matrix(df[,which(colnames(df)==beat)]),na.rm = T)  # fix to avoid NAs
    # Optional, recode new number for each cycle
    L <- round(nrow(df)/beat_N) # was round
    df$cycle<-NA
    df$cycle<- rep(1:L,each=beat_N,length.out=round(nrow(df)))
    # if the number of beats is not even to the cycle, put NA to trailing beats
    C_len <- round(nrow(df)/L)*L
    DF_len<-nrow(df)
    DIF <- DF_len - C_len
    if(abs(DIF)!=0){
      df$cycle[(DF_len-DIF+1):DF_len]<-NA
    }  
    # Calculate isochrony based on the average onset of the first beat 
    df2 <- df %>% dplyr::select(all_of(instr)) %>% dplyr::mutate(mean_onset=rowMeans(.,na.rm = TRUE))
    df$mean_onset<-df2$mean_onset
    df$mean_onset[df$mean_onset=='NaN']<-NA
    
    DF <- NULL
    for(k in 1:(max(df$cycle,na.rm = TRUE)-1)){
      #    print(k)
      tmp<-dplyr::filter(df,cycle==k)
      tmp_next<-dplyr::filter(df,cycle==k+1)
      if(is.na(tmp$mean_onset[1]) | is.na(tmp_next$mean_onset[1])){
        s<-rep(NA,beat_N+1);
      }
      if(!is.na(tmp$mean_onset[1]) & !is.na(tmp_next$mean_onset[1])){ # fixed brackets
        s<-seq(tmp$mean_onset[1],tmp_next$mean_onset[1],length.out = beat_N+1)
      }
      tmp$iso<-s[1:beat_N]
      DF<-rbind(DF,tmp)
    }
    # relabel output iso
    names(DF)[which(names(DF)=='iso')]<-beatlabel
    DF <- dplyr::select(DF,-cycle,-mean_onset)    # drop unless needed explicitly
  }
  return <- DF
}

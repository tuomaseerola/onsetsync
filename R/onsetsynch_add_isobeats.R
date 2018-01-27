#' onsetsynch_add_isobeats
#'
#' Add isochronous beats to a onset datafame based on beat levels and average onset of the 1st beat
#'
#' @param df data frame to be processed
#' @param instr variable which contains the instruments
#' @param beat variable which contains the beats
#' @return dataframe with added column of isochronous beats and cycle numbers
#' @export

onsetsynch_add_isobeats <- function(df,instr,beat){
  
  # T. Eerola, Durham University, IEMP project
  # 22/1/2018  
  
  #_ beat<-'SD'
  beat_N <- max(as.matrix(df[,which(colnames(df)==beat)]))  
  
  # Optional, recode new number for each cycle
  L <- round(nrow(df)/beat_N)
  df$cycle<- rep(1:L,each=beat_N,length.out=round(nrow(df)))
  # if the number of beats is not even to the cycle, put NA to trailing beats
  C_len <- round(nrow(df)/L)*L
  DF_len<-nrow(df)
  DIF <- DF_len - C_len
  df$cycle[(DF_len-DIF+1):DF_len]<-NA
  
  # Calculate isochrony based on the average onset of the first beat 
  df2 <- df %>% select(instr) %>% dplyr::mutate(mean_onset=rowMeans(.,na.rm = TRUE))
  df$mean_onset<-df2$mean_onset
  df$mean_onset[df$mean_onset=='NaN']<-NA
  
  # df3<-df2 %>%
  #   mutate(
  #     iso = case_when(
  #       iso>1 ~ seq(iso,lag(iso,16)),
  #       TRUE                      ~  0
  #     )
  #   )
  
  DF<-NULL
  for(k in 1:(max(df$cycle,na.rm = TRUE)-1)){
    #  print(k)
    tmp<-dplyr::filter(df,cycle==k)
    tmp_next<-dplyr::filter(df,cycle==k+1)
    if(is.na(tmp$mean_onset[1] | is.na(tmp_next$mean_onset[1]))){
      s<-rep(NA,beat_N+1)
    }
    if(!is.na(tmp$mean_onset[1] & !is.na(tmp_next$mean_onset[1]))){ # Fix this, NaN, not NA
      s<-seq(tmp$mean_onset[1],tmp_next$mean_onset[1],length.out = beat_N+1)
    }
    tmp$iso<-s[1:beat_N]
    DF<-rbind(DF,tmp)
  }
  return<-DF
}
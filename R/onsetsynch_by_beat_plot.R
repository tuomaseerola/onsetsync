#' plot synchronies by beat structures
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed
#' @param instr Instrument name to be processed
#' @param beat Variable name where the beats are
#' @param virtual Variable name where the virtual beats are
#' @param pcols Number of columns for multiple plots
#' @return Graphic output
#' @export

onsetsynch_by_beat_plot <-function(df,instr,beat,virtual,pcols){

# T. Eerola, Durham University, IEMP project
# 14/1/2018  
# needs work
  
## FOR EACH INSTRUMENT, CALCULATE DEVIATION AND CREATE MATRIX

DF<-NULL
tmp<-NULL

for(k in 1:length(instr)){
  print(instr[k])
  tmp <- select(df,c(instr[k],beat,virtual))
  head(tmp)
  colnames(tmp)<-c('instr','beat','virtual')
  tmp <- mutate(tmp,VSD = instr - virtual)  # absolute time
  tmp <- mutate(tmp,VSDR = VSD/(virtual-lag(virtual)))  # proportion of interbeat
  tmp$name<-instr[k]
  DF<-rbind(DF,tmp)
}

DF$name<-factor(DF$name) # TURN names INTO A FACTOR

## PLOT
g1<-ggplot2::ggplot(DF,aes(x=(beat + VSDR),y=instr,colour=name))+
  geom_point(size=1,na.rm=TRUE)+
  scale_x_continuous(breaks = seq(1,max(DF$beat)))+
  scale_color_brewer(name="Instr.",palette = 'Spectral',type="div")+
  facet_wrap(~name,ncol=pcols)+
  xlab('Beat')+
  ylab('Time (s)')+
  theme_bw()
g1  
return <- g1  
}

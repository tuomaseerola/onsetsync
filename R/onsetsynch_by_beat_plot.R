#' plot synchronies by beat structures
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed
#' @param instr Instrument name to be processed
#' @param beat Variable name where the beats are
#' @param virtual Variable name where the virtual beats are
#' @param pcols Number of columns for multiple plots (default 1)
#' @param griddeviations Add deviation from the virtual beats in %
#' @param box Do the graphics by boxplot
#' @param colour colour for the boxplot
#' @return Graphic output
#' @export

onsetsynch_by_beat_plot <-function(df,instr,beat,virtual,pcols=1,griddeviations=FALSE,box=FALSE,colour='lightblue'){

# T. Eerola, Durham University, IEMP project
# 23/1/2018  
# needs work

# for testing  
 # df<-asere
 # instr<-c('Bass','Tres','Bell')
 # beat<-'SD'
 # virtual<-'Virtual.SD'
 # pcols<-2
 # box<-TRUE
 # griddeviations<-FALSE

 ## FOR EACH INSTRUMENT, CALCULATE DEVIATION AND CREATE MATRIX

DF<-NULL
tmp<-NULL
S<-NULL
s<-NULL
#print(instr)
for(k in 1:length(instr)){
#  print(instr[k])
  tmp <- select(df,c(instr[k],beat,virtual))
#  head(tmp)
  colnames(tmp)<-c('instr','beat','virtual')
  tmp <- mutate(tmp,VSD = instr - virtual)  # absolute time difference
  tmp <- mutate(tmp,VSDR = VSD/(virtual-lag(virtual)))  # proportion of interbeat
  tmp$name<-instr[k]
  DF<-rbind(DF,tmp)
  # extra labelling
  tmp$beatF<-factor(tmp$beat)
  s<-summarise(group_by(tmp,beatF), M=mean(VSDR*100,na.rm = TRUE))
  s$Time<-min(DF$instr,na.rm = TRUE)
  s$name<-unique(tmp$name)
  S<-rbind(S,s)
}

DF$name<-factor(DF$name) # TURN names INTO A FACTOR
S$name<-factor(S$name) # TURN names INTO A FACTOR

## PLOT
if(griddeviations==FALSE){
#  print('false...')
  g1<-ggplot2::ggplot(DF,aes(x=(beat + VSDR),y=instr,colour=name))+
    geom_point(size=1,na.rm=TRUE)+
    scale_x_continuous(breaks = seq(1,max(DF$beat)))+
    scale_color_brewer(name="Instr.",palette = 'Set1',type="div")+
    facet_wrap(~name,ncol=pcols)+
    xlab(paste('Beat (',beat,')',sep=''))+
    ylab('Time (s)')+
    theme_bw()
g1  
}

## PLOT with metrical grid deviations
  if(griddeviations==TRUE){
    S$label<-paste(round(S$M,digits = 0),'%',sep='')
    S$beat<-as.integer(S$beatF)
    
  
g1<-ggplot2::ggplot(DF,aes(x=(beat + VSDR),y=instr,colour=name))+
  geom_point(size=1,na.rm=TRUE)+
  scale_x_continuous(breaks = seq(1,max(DF$beat)))+
  scale_color_brewer(name="Instr.",palette = 'Set1',type="div")+ # was Spectral
  facet_wrap(~name,ncol=pcols)+
  xlab(paste('Beat (',beat,')',sep=''))+
  ylab('Time (s)')+
  theme_bw() +
 geom_text(
  data    = S,
  mapping = aes(x = beat, y = 5, label = label),
  hjust   = 0.5,
  size = 2.5,
  angle = 0,
  color = "black",
  vjust   = -1
)

# g1

  }

if(box==TRUE){
DF$beatF<-factor(DF$beat)

  g1 <- ggplot2::ggplot(DF,aes(x=(beatF),y=VSD*1000))+
    geom_boxplot(na.rm=TRUE,outlier.colour = "gray80",outlier.size = 0.25,fill=colour)+
    scale_x_discrete(breaks = seq(1,max(DF$beat)))+
    facet_wrap(~name,ncol=pcols)+
    xlab(paste('Beat (',beat,')',sep=''))+
    ylab('Asynchrony (ms)')+
    theme_bw()
#g1  
}
return <- g1  
}

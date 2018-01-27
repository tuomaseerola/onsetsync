#' plot synchronies by beat structures
#'
#' This function plots the calculated asynchronies of instruments and labels these by instruments.
#'
#' @param df data frame to be processed
#' @param data Variable name where the beats are
#' @param pcols Number of columns for multiple plots (default 1)
#' @param box Do the graphics by boxplot
#' @param colour colour for the boxplot
#' @return Graphic output
#' @export

onsetsynch_by_dataset_plot <-function(df,asynchronies,data,pcols=1,box=FALSE,colour='lightblue'){

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
print(data)
print(asynchronies)

DF<-select(df,asynchronies,data)
colnames(DF)<-c('asynch','data')
print(head(DF))

g1<-ggplot2::ggplot(DF,aes(asynch,fill = data),colour = 'black')+
    geom_density(alpha=1)+
#    scale_x_continuous(breaks = seq(1,max(DF$beat)))+
    scale_color_brewer(name="Dataset",palette = 'Set1',type="div")+
    facet_wrap(~data,pcols)+
    xlab(paste('Asynchrony (ms)'))+
    ylab('Density')+
    theme_bw()
#g1  

if(box==TRUE){
  
  m<-summarise(group_by(DF,data),m=median(asynch),count=n())
  
  g1 <- ggplot2::ggplot(DF,aes(data,asynch,fill=data))+
    geom_boxplot(outlier.colour = "gray80",outlier.size = 0.25,)+
    scale_color_brewer(name="Dataset",palette = 'Set1',type="div")+
    #    geom_boxplot(na.rm=TRUE,outlier.colour = "gray80",outlier.size = 0.25,fill=colour)+
#    scale_x_discrete(breaks = seq(1,max(DF$beat)))+
#    facet_wrap(~data,ncol=pcols)+
    xlab('Dataset')+
    ylab('Asynchrony (ms)')+
    annotate("text",x=as.numeric(m$data),y=m$m,label=paste("N=",m$count,sep=""))+
    theme_bw()
g1  
}
return <- g1  
}

## ----load, warning=FALSE,message=FALSE----------------------------------------
library(onsetsync)
data <- CSS_IEMP[[2]]                                                          # example
data <- dplyr::filter(data,Isochronous.SD.Time > 5 & Isochronous.SD.Time < 15) # 10 s
data$Guitar <- data$Guitar - min(data$Isochronous.SD.Time,na.rm = TRUE)        # trim time     
data$Bass <- data$Bass - min(data$Isochronous.SD.Time,na.rm = TRUE)            # trim time

## ----createwave, echo=TRUE----------------------------------------------------
inst <- c('Guitar','Bass')
fs <- 22050
w <- synthesise_onsets(data=data,instruments = inst, sr = fs, type =c('synth','noise'))

## ---- echo=TRUE,fig.width=6.5,fig.height=2.5----------------------------------
scaling <- 20
ws <- signal::resample(w,fs,fs*scaling)
tmp <- data.frame(Amplitude=ws,Time=seq(0,length(ws)-1))
tmp$Time <- tmp$Time/fs*scaling
ggplot2::ggplot(tmp,ggplot2::aes(x=Time,y=Amplitude))+
  ggplot2::geom_line(color='blue')+
  ggplot2::theme_linedraw()

## ----savefile, echo=TRUE, eval=FALSE------------------------------------------
#  seewave::savewav(wave = w, f = fs, channel = 1, filename = 'example.wav')


## ----eval=FALSE---------------------------------------------------------------
#  if (!require(devtools)) install.packages("devtools")
#  devtools::install_github("tuomaseerola/onsetsync")

## ---- message=FALSE, warning=FALSE,echo=TRUE----------------------------------
library(onsetsync)
library(dplyr)
library(ggplot2)
packageVersion("onsetsync")

## ----message=FALSE,warning=FALSE,eval=TRUE,results='asis'---------------------
CSS_Song2 <- onsetsync::CSS_IEMP[[2]]   # Read one song from internal data
CSS_Song2 <- dplyr::select(CSS_Song2,Label.SD,SD,Clave,Bass,Guitar,Tres,
                           CycleTime,Cycle,Isochronous.SD.Time) # Select some columns
print(knitr::kable(head(CSS_Song2),format = "simple",digits = 2))

## ----synch2isochron,fig.width=7, fig.asp=.75----------------------------------
fig1 <- plot_by_beat(df = CSS_Song2, 
                     instr = c('Bass','Clave','Guitar','Tres'), 
                     beat = 'SD', 
                     virtual='Isochronous.SD.Time',
                     pcols=2)
print(fig1)

## ----fig2,warning=FALSE,fig.width=7, fig.asp=.7-------------------------------
inst <- c('Clave','Bass','Guitar','Tres') # Define instruments 
dn <- sync_execute_pairs(CSS_Song2,inst,beat = 'SD')
fig2 <- plot_by_pair(dn)  # plot
print(fig2)  

## ----paired1------------------------------------------------------------------
set.seed(1234) # set random seed
N <- 200 # Let's select 200 onsets
Bootstrap <- 100
d1 <- sync_sample_paired(df = CSS_Song2, 
                         instr1 = 'Clave',
                         instr2 = 'Bass',
                         n = N, 
                         bootn = Bootstrap,
                         beat = 'SD')
dplyr::summarise(data.frame(d1), N=n(), M = mean(asynch*1000), SD = sd(asynch*1000))

## ----corpus, warning=FALSE, message=FALSE, eval=TRUE,fig.width=6.0------------
corpus <- onsetsync::CSS_IEMP
D <- sync_sample_paired(corpus,'Tres','Bass', beat = 'SD')
D <- D$asynch
D$asynch_abs <- abs(D$asynch)*1000
fig3 <- plot_by_dataset(D,'asynch_abs','name', box = TRUE)
print(fig3)


library(dplyr)
library(ggplot2)

# read data 
CSS_Song2 <- onsetsync::CSS_IEMP[[2]]
# choose only some instruments
CSS_Song2 <- dplyr::select(CSS_Song2,Label.SD,SD,Clave,Bass,Guitar,Tres,
                           CycleTime,Cycle,Isochronous.SD.Time) # Select some columns
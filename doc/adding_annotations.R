## ----load, warning=FALSE,message=FALSE----------------------------------------
library(onsetsync)
require(httr)
CSS_Song2_Onset <- get_OSF_csv('8a347') # Get onsets
print(head(CSS_Song2_Onset[,1:8,]))

## ----showannotations, echo=TRUE-----------------------------------------------
CSS_Song2_Metre <- get_OSF_csv('4cdpr') # Annotations for cycles
print(head(CSS_Song2_Metre))

## ----simplify_example, echo=TRUE----------------------------------------------
CSS_Song2_Onset <- dplyr::select(CSS_Song2_Onset,
                  Label.SD,SD,Clave,Bass,Guitar,Tres) 

## ----enrich1, echo=TRUE-------------------------------------------------------
# Add annotations about the cycle to the data frame
CSS_Song2 <- add_annotation(df = CSS_Song2_Onset,
                            annotation = CSS_Song2_Metre$Cycle,
                            time = CSS_Song2_Metre$Time,
                            reference = 'Label.SD')

## ----enrich2, echo=TRUE-------------------------------------------------------
# Add isochronous beats to the data frame
CSS_Song2 <- add_isobeats(df = CSS_Song2, 
                          instr = 'CycleTime', 
                          beat = 'SD')
print(head(CSS_Song2[,2:9]))

## ----enrich3, echo=TRUE-------------------------------------------------------
colnames(CSS_Song2)[9] <- 'Ann.Iso' # Rename
# Add isochronous beats based on mean timing of guitar, tres, and clave

CSS_Song2 <- add_isobeats(df = CSS_Song2, 
                          instr = c('Guitar','Tres','Clave'), 
                          beat = 'SD')
# Show the newly calculated isochronous beat times 
# from the second cycle onwards.
print(head(CSS_Song2[17:22,c(2,6:10)]))

